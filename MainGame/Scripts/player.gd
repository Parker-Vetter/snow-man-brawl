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
@onready var launcher1: Sprite2D = $launcher1
@onready var launcher1_anim: AnimationPlayer = $launcher1/AnimationPlayer
@onready var launcher2: Sprite2D = $launcher2
@onready var launcher2_anim: AnimationPlayer = $launcher2/AnimationPlayer
@onready var launcher3: Sprite2D = $launcher3
@onready var launcher3_anim: AnimationPlayer = $launcher3/AnimationPlayer
@onready var launcher4: Sprite2D = $launcher4
@onready var launcher4_anim: AnimationPlayer = $launcher4/AnimationPlayer
@onready var backpack: AnimatedSprite2D = $backpack
@onready var breath: AnimatedSprite2D = $breath
@onready var footprint_spawner: Marker2D = $FootprintSpawner
var footprint_texture = preload("res://zacks sprites/footprint.png")

# Reload snowball sprites and their marker positions
@onready var reload_snowball_1: Sprite2D = $ReloadedSnowball1
@onready var reload_snowball_2: Sprite2D = $ReloadedSnowball2
@onready var reload_snowball_3: Sprite2D = $ReloadedSnowball3
@onready var reload_snowball_4: Sprite2D = $ReloadedSnowball4
@onready var snowball_pos_1: Marker2D = $launcher1/SnowballRespawn1
@onready var snowball_pos_2: Marker2D = $launcher2/SnowballRespawn2
@onready var snowball_pos_3: Marker2D = $launcher3/SnowballRespawn3
@onready var snowball_pos_4: Marker2D = $launcher4/SnowballRespawn4

@onready var projectile = load("res://MainGame/Scenes/projectile.tscn")

@export var targetDistance = 150

# Footprint settings
var footprint_fade_time: float = 2.0  # Time before footprint starts fading
var footprint_fade_duration: float = 1.0  # Duration of fade out


var maxSpeed: float = 100
var shootDelay: float = 2

var shootTimer: Timer
var pendingTarget: Node2D = null
var pendingArmIsLeft: bool = false
var pendingAutoTargets: Dictionary = {}  # Maps enemy -> timestamp when targeted
const PENDING_TARGET_TIMEOUT: float = 0.5  # Seconds before target becomes available again

# Timer references for auto-launchers (stored as class vars to ensure they're not lost)
var auto_timer1: Timer
var auto_timer2: Timer
var auto_timer3: Timer
var auto_timer4: Timer

# Tween references for reload snowballs (to kill them when firing)
var reload_tweens: Dictionary = {}

# Breath animation timing
var breath_timer: float = 0.0
const BREATH_BASE_INTERVAL: float = 2.0  # Base 2 second buffer
const BREATH_MIN_INTERVAL: float = 0.3   # Minimum interval when moving fast

func _ready() -> void:
	var gameData: GameData = main.gameData
	maxSpeed = gameData.player_move_speed
	armSprite.frame_changed.connect(_on_arm_frame_changed)
	armSpriteL.frame_changed.connect(_on_arm_L_frame_changed)
	sprite.frame_changed.connect(_on_sprite_frame_changed)
	breath.stop()  # Stop autoplay, we control timing via breath_timer
	shootTimer = Timer.new()
	shootDelay = 1 / gameData.throw_rate
	shootTimer.wait_time = shootDelay
	shootTimer.timeout.connect(_on_shoot_timer_timeout)
	add_child(shootTimer)
	shootTimer.start()

	# Base animation is 0.5 sec, only speed up if fire rate requires it
	var anim_speed = max(1.0, gameData.auto_backpack_fire_rate * 0.5)

	# Hide backpack if no launchers active
	if is_instance_valid(backpack):
		backpack.visible = gameData.auto_backpack > 0

	var base_interval = 1 / gameData.auto_backpack_fire_rate

	if gameData.auto_backpack > 0:
		auto_timer1 = bullet_origin_1.get_node("Timer")
		auto_timer1.wait_time = base_interval
		auto_timer1.start()
		if is_instance_valid(launcher1):
			launcher1.visible = true
			launcher1_anim.speed_scale = anim_speed
		if is_instance_valid(reload_snowball_1):
			reload_snowball_1.visible = true
			start_reload_effect(reload_snowball_1, base_interval)
		print("[Launcher] Timer 1 started, wait_time: ", auto_timer1.wait_time)
	else:
		if is_instance_valid(launcher1):
			launcher1.visible = false
		if is_instance_valid(reload_snowball_1):
			reload_snowball_1.visible = false
	if gameData.auto_backpack > 1:
		auto_timer2 = bullet_origin_2.get_node("Timer")
		auto_timer2.wait_time = base_interval
		if is_instance_valid(launcher2):
			launcher2.visible = true
			launcher2_anim.speed_scale = anim_speed
		if is_instance_valid(reload_snowball_2):
			reload_snowball_2.visible = true
		# Stagger: delay start by 25% of interval
		get_tree().create_timer(base_interval * 0.25).timeout.connect(func():
			auto_timer2.start()
			if is_instance_valid(reload_snowball_2):
				start_reload_effect(reload_snowball_2, base_interval)
		)
		print("[Launcher] Timer 2 will start in: ", base_interval * 0.25)
	else:
		if is_instance_valid(launcher2):
			launcher2.visible = false
		if is_instance_valid(reload_snowball_2):
			reload_snowball_2.visible = false
	if gameData.auto_backpack > 2:
		auto_timer3 = bullet_origin_3.get_node("Timer")
		auto_timer3.wait_time = base_interval
		if is_instance_valid(launcher3):
			launcher3.visible = true
			launcher3_anim.speed_scale = anim_speed
		if is_instance_valid(reload_snowball_3):
			reload_snowball_3.visible = true
		# Stagger: delay start by 50% of interval
		get_tree().create_timer(base_interval * 0.5).timeout.connect(func():
			auto_timer3.start()
			if is_instance_valid(reload_snowball_3):
				start_reload_effect(reload_snowball_3, base_interval)
		)
		print("[Launcher] Timer 3 will start in: ", base_interval * 0.5)
	else:
		if is_instance_valid(launcher3):
			launcher3.visible = false
		if is_instance_valid(reload_snowball_3):
			reload_snowball_3.visible = false
	if gameData.auto_backpack > 3:
		auto_timer4 = bullet_origin_4.get_node("Timer")
		auto_timer4.wait_time = base_interval
		if is_instance_valid(launcher4):
			launcher4.visible = true
			launcher4_anim.speed_scale = anim_speed
		if is_instance_valid(reload_snowball_4):
			reload_snowball_4.visible = true
		# Stagger: delay start by 75% of interval
		get_tree().create_timer(base_interval * 0.75).timeout.connect(func():
			auto_timer4.start()
			if is_instance_valid(reload_snowball_4):
				start_reload_effect(reload_snowball_4, base_interval)
		)
		print("[Launcher] Timer 4 will start in: ", base_interval * 0.75)
	else:
		if is_instance_valid(launcher4):
			launcher4.visible = false
		if is_instance_valid(reload_snowball_4):
			reload_snowball_4.visible = false

func start_reload_effect(snowball: Sprite2D, duration: float) -> void:
	# Kill any existing tween for this snowball
	if reload_tweens.has(snowball) and reload_tweens[snowball] != null:
		reload_tweens[snowball].kill()
	snowball.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(snowball, "modulate:a", 1.0, duration)
	reload_tweens[snowball] = tween

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

func spawn_projectile(target: Node2D, origin: Marker2D = null, flip_origin: bool = true):
	if origin == null:
		origin = bulletOrigin
	var instance = projectile.instantiate()
	instance.main = main
	var shootAngle = position.direction_to(target.global_position).angle()
	instance.dir = shootAngle - PI / 2
	var originPos = origin.position
	if flip_origin and sprite.flip_h:
		originPos.x = - originPos.x
	instance.spawnPos = position + originPos
	instance.spawnRot = shootAngle
	instance.spinSpeed = randf_range(-300, 300)
	instance.gameData = main.gameData
	main.gameData.snow_balls_thrown += 1
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
		armSprite.position.x = abs(armSprite.position.x)
		armSpriteL.flip_h = false
		breath.flip_h = false
		breath.position.x = abs(breath.position.x)
		# Ensure footprint spawner sits on the right side when facing right
		footprint_spawner.position.x = abs(footprint_spawner.position.x)
		for mask in masks.get_children():
			mask.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true
		armSprite.flip_h = true
		armSprite.position.x = -abs(armSprite.position.x)
		armSpriteL.flip_h = true
		breath.flip_h = true
		breath.position.x = -abs(breath.position.x)
		# Ensure footprint spawner sits on the left side when facing left
		footprint_spawner.position.x = -abs(footprint_spawner.position.x)
		for mask in masks.get_children():
			mask.flip_h = true

	#play run or idle animation
	const BASE_MOVE_SPEED: float = 100.0
	if velocity.length() > 0:
		sprite.play("run")
		var animScale = sqrt(velocity.length() / BASE_MOVE_SPEED) * 2.0
		sprite.speed_scale = clamp(animScale, 0.5, 4.0)
	else:
		sprite.play("idle")
		sprite.speed_scale = 1.0

	# Update reload snowball positions to follow their markers
	reload_snowball_1.global_position = snowball_pos_1.global_position
	reload_snowball_2.global_position = snowball_pos_2.global_position
	reload_snowball_3.global_position = snowball_pos_3.global_position
	reload_snowball_4.global_position = snowball_pos_4.global_position

	# Breath animation with speed-based interval
	var speed_ratio = velocity.length() / maxSpeed
	var breath_interval = lerp(BREATH_BASE_INTERVAL, BREATH_MIN_INTERVAL, speed_ratio)
	breath_timer -= _delta
	if breath_timer <= 0:
		breath.play("default")
		breath_timer = breath_interval

func _on_sprite_frame_changed() -> void:
	if sprite.animation == "run" and (sprite.frame == 1 or sprite.frame == 8):
		spawn_footprint()

func spawn_footprint() -> void:
	var footprint = Sprite2D.new()
	footprint.texture = footprint_texture
	# Center the footprint texture so the position refers to its center
	if footprint.texture:
		footprint.centered = true
		# Place exactly at the FootprintSpawner marker position (no offset)
		footprint.global_position = footprint_spawner.global_position
	else:
		footprint.global_position = footprint_spawner.global_position
	footprint.flip_h = sprite.flip_h
	# Add to Footprints node (if present) so it stays in world space and is organized
	var container: Node = main
	if main.has_node("Footprints"):
		container = main.get_node("Footprints")
	container.add_child(footprint)

	# Fade out and remove footprint
	var tween = create_tween()
	tween.tween_interval(footprint_fade_time)
	tween.tween_property(footprint, "modulate:a", 0.0, footprint_fade_duration)
	tween.tween_callback(footprint.queue_free)

func _on_hit_box_area_entered(area: Area2D) -> void:
	print("hit group", area.name)
	if area.name == "HitBox":
		if area.get_parent().is_in_group("enemies"):
			main.pause_and_death_menu()

func _on_pickup_radius_area_entered(area: Area2D) -> void:
	if area.is_in_group("pickup"):
		if area.has_method("pickup"):
			area.pickup(self)

func find_nearest_untargeted_enemy() -> Node2D:
	var current_time = Time.get_ticks_msec() / 1000.0

	# Clean up invalid or expired targets
	var to_remove = []
	for enemy in pendingAutoTargets:
		if not is_instance_valid(enemy):
			to_remove.append(enemy)
		elif current_time - pendingAutoTargets[enemy] > PENDING_TARGET_TIMEOUT:
			to_remove.append(enemy)
	for enemy in to_remove:
		pendingAutoTargets.erase(enemy)

	# Find the nearest enemy that is not in the pendingAutoTargets dictionary
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
		spawn_projectile(target, bullet_origin_1, false)
		pendingAutoTargets[target] = Time.get_ticks_msec() / 1000.0
		launcher1_anim.play("shoot")
	start_reload_effect(reload_snowball_1, auto_timer1.wait_time)

func _on_timer_timeout_BO2() -> void:
	var target = find_nearest_untargeted_enemy()
	if target:
		spawn_projectile(target, bullet_origin_2, false)
		pendingAutoTargets[target] = Time.get_ticks_msec() / 1000.0
		launcher2_anim.play("shoot")
	start_reload_effect(reload_snowball_2, auto_timer2.wait_time)

func _on_timer_timeout_BO3() -> void:
	var target = find_nearest_untargeted_enemy()
	if target:
		spawn_projectile(target, bullet_origin_3, false)
		pendingAutoTargets[target] = Time.get_ticks_msec() / 1000.0
		launcher3_anim.play("shoot")
	start_reload_effect(reload_snowball_3, auto_timer3.wait_time)

func _on_timer_timeout_BO4() -> void:
	var target = find_nearest_untargeted_enemy()
	if target:
		spawn_projectile(target, bullet_origin_4, false)
		pendingAutoTargets[target] = Time.get_ticks_msec() / 1000.0
		launcher4_anim.play("shoot")
	start_reload_effect(reload_snowball_4, auto_timer4.wait_time)

func setMask(data: PickupData):
	for child in masks.get_children():
		if is_instance_valid(child):
			child.visible = false
	var mask = masks.get_node(str(data.id))
	if mask and is_instance_valid(mask):
		mask.visible = true
