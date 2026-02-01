extends CharacterBody2D
class_name Player

@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var bulletOrigin: Marker2D = $BulletOrigin
@onready var bullet_origin_1: Marker2D = $BulletOrigin1
@onready var bullet_origin_2: Marker2D = $BulletOrigin2
@onready var bullet_origin_3: Marker2D = $BulletOrigin3
@onready var bullet_origin_4: Marker2D = $BulletOrigin4
@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var armSprite: AnimatedSprite2D = $"arm R"
@onready var armSpriteL: AnimatedSprite2D = $"arm L"
@onready var bulletOriginL: Marker2D = $"BulletOrigin L"
@onready var main: MainGame = $".."
@onready var masks: Marker2D = $Masks
@onready var throw_sound: AudioStreamPlayer = $Impact

@onready var projectile = load("res://MainGame/Scenes/projectile.tscn")

#When object enters scene, make a variable pointed to the AudiostreamNode
@onready var music1: Node = $Music
@export var targetDistance = 150


var maxSpeed: float = 100
var shootDelay: float = 2

var shootTimer: Timer
var pendingTarget: Node2D = null
var pendingArmIsLeft: bool = false
var pendingAutoTargets: Array[Node2D] = []

func _ready() -> void:
	var gameData: GameData = main.gameData
	maxSpeed = gameData.player_move_speed
	armSprite.frame_changed.connect(_on_arm_frame_changed)
	armSpriteL.frame_changed.connect(_on_arm_L_frame_changed)
	shootTimer = Timer.new()
	shootDelay = 1 / gameData.throw_rate
	shootTimer.wait_time = shootDelay
	shootTimer.timeout.connect(_on_shoot_timer_timeout)
	add_child(shootTimer)
	shootTimer.start()

	if gameData.auto_backpack > 0:
		var timer = bullet_origin_1.get_node("Timer")
		timer.wait_time = 1 / gameData.auto_backpack_fire_rate
		timer.start()
	if gameData.auto_backpack > 1:
		var timer = bullet_origin_2.get_node("Timer")
		timer.wait_time = 1 / gameData.auto_backpack_fire_rate
		timer.start()
	if gameData.auto_backpack > 2:
		var timer = bullet_origin_3.get_node("Timer")
		timer.wait_time = 1 / gameData.auto_backpack_fire_rate
		timer.start()
	if gameData.auto_backpack > 3:
		var timer = bullet_origin_4.get_node("Timer")
		timer.wait_time = 1 / gameData.auto_backpack_fire_rate
		timer.start()

func _on_shoot_timer_timeout():
	var target = get_nearest_enemy()
	if target:
		shoot(target)

func get_nearest_enemy() -> Node2D:
	var enemies = get_tree().get_nodes_in_group("enemies")
	var nearest: Node2D = null
	var nearest_dist = INF
	for enemy in enemies:
		var dist = position.distance_to(enemy.position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest = enemy
	return nearest

func shoot(target: Node2D):
	pendingTarget = target
	# Choose arm based on whether enemy is in front or behind player
	var enemy_is_right = target.global_position.x >= global_position.x
	var player_facing_right = not sprite.flip_h
	var enemy_in_front = enemy_is_right == player_facing_right
	throw_sound.play()
	if enemy_in_front:
		# Enemy in front - use right arm
		pendingArmIsLeft = false
		armSprite.frame = 0
		armSprite.play("throw")
	else:
		# Enemy behind - use left arm
		pendingArmIsLeft = true
		armSpriteL.frame = 0
		armSpriteL.play("throw")

func _on_arm_frame_changed():
	if armSprite.frame == 3 and pendingTarget and is_instance_valid(pendingTarget) and not pendingArmIsLeft:
		spawn_projectile(pendingTarget)
		pendingTarget = null

func _on_arm_L_frame_changed():
	if armSpriteL.frame == 3 and pendingTarget and is_instance_valid(pendingTarget) and pendingArmIsLeft:
		spawn_projectile(pendingTarget, bulletOriginL)
		pendingTarget = null

func spawn_projectile(target: Node2D, origin: Marker2D = null):
	if origin == null:
		origin = bulletOrigin
	var instance = projectile.instantiate()
	instance.main = main
	var shootAngle = position.direction_to(target.global_position).angle()
	instance.dir = shootAngle - PI / 2
	var originPos = origin.position
	if sprite.flip_h:
		originPos.x = - originPos.x
	instance.spawnPos = position + originPos
	instance.spawnRot = shootAngle
	instance.spinSpeed = randf_range(-300, 300)
	instance.gameData = main.gameData
	main.add_child.call_deferred(instance)

func _physics_process(_delta: float):
	#move toward the mouse
	var globalMouse = get_global_mouse_position()
	var distance = globalMouse.distance_to(position)
	var fromDestination = max(0, distance - targetDistance)
	var vel: Vector2 = position.direction_to(globalMouse) * fromDestination
	vel = vel.limit_length(maxSpeed)
	velocity = vel
	move_and_slide()

	#flip sprite based on movement direction
	if velocity.x > 0:
		sprite.flip_h = false
		armSprite.flip_h = false
		armSpriteL.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true
		armSprite.flip_h = true
		armSpriteL.flip_h = true

	#play run or idle animation
	if velocity.length() > 0:
		sprite.play("run")
		sprite.speed_scale = velocity.length() / maxSpeed * 2.0
	else:
		sprite.play("idle")
		sprite.speed_scale = 1.0
	# Every frame, check velocity of Player. If moving, make one stream loud other quiett. If still, reverse.
	if velocity == Vector2(0, 0):
		#moving = false
		music1.stream.set_sync_stream_volume(0, 0)
		music1.stream.set_sync_stream_volume(1, -64)
		
	if velocity > Vector2(0, 0):
		#moving = true
		music1.stream.set_sync_stream_volume(1, 0)
		music1.stream.set_sync_stream_volume(0, -64)

func _on_hit_box_area_entered(area: Area2D) -> void:
	print("hit group", area.name)
	if area.name == "HitBox":
		if area.get_parent().is_in_group("enemies"):
			main.switchToPeggleDrop()

func _on_pickup_radius_area_entered(area: Area2D) -> void:
	if area.is_in_group("pickup"):
		if area.has_method("pickup"):
			area.pickup(self)

func find_nearest_untargeted_enemy() -> Node2D:
	# Clean up invalid targets
	for i in range(pendingAutoTargets.size() - 1, -1, -1):
		if not is_instance_valid(pendingAutoTargets[i]):
			pendingAutoTargets.remove_at(i)
	# Find the nearest enemy that is not in the pendingAutoTargets array
	var enemies = get_tree().get_nodes_in_group("enemies")
	var nearest: Node2D = null
	var nearest_dist = INF
	for enemy in enemies:
		if not enemy in pendingAutoTargets:
			var dist = position.distance_to(enemy.position)
			if dist < nearest_dist:
				nearest_dist = dist
				nearest = enemy
	return nearest

func _on_timer_timeout_BO1() -> void:
	var target = find_nearest_untargeted_enemy()
	if target:
		spawn_projectile(target, bullet_origin_1)
		pendingAutoTargets.append(target)

func _on_timer_timeout_BO2() -> void:
	var target = find_nearest_untargeted_enemy()
	if target:
		spawn_projectile(target, bullet_origin_2)
		pendingAutoTargets.append(target)

func _on_timer_timeout_BO3() -> void:
	var target = find_nearest_untargeted_enemy()
	if target:
		spawn_projectile(target, bullet_origin_3)
		pendingAutoTargets.append(target)

func setMask(data: PickupData):
	for child in masks.get_children():
		child.visible = false
	var mask = masks.get_node(str(data.id))
	if mask:
		mask.visible = true
