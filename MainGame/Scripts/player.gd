extends CharacterBody2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var bulletOrigin: Marker2D = $BulletOrigin
@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var armSprite: AnimatedSprite2D = $arm

@onready var main = get_tree().get_root().get_node("MainGame")
@onready var projectile = load("res://MainGame/Scenes/projectile.tscn")

@export var maxSpeed = 100
@export var targetDistance = 150
## Shooting rate in shots per second
@export var shootDelay: float = 2

var shootTimer: Timer
var pendingTarget: Node2D = null

func _ready() -> void:
	armSprite.frame_changed.connect(_on_arm_frame_changed)
	shootTimer = Timer.new()
	shootTimer.wait_time = shootDelay
	shootTimer.timeout.connect(_on_shoot_timer_timeout)
	add_child(shootTimer)
	shootTimer.start()

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
	#play arm animation - projectile spawns on frame 3
	armSprite.frame = 0
	armSprite.play("throw")

func _on_arm_frame_changed():
	if armSprite.frame == 3 and pendingTarget and is_instance_valid(pendingTarget):
		spawn_projectile(pendingTarget)
		pendingTarget = null

func spawn_projectile(target: Node2D):
	var instance = projectile.instantiate()
	var shootAngle = position.direction_to(target.global_position).angle()
	instance.dir = shootAngle - PI / 2
	var originPos = bulletOrigin.position
	if sprite.flip_h:
		originPos.x = - originPos.x
	instance.spawnPos = position + originPos
	instance.spawnRot = shootAngle
	instance.spinSpeed = randf_range(-300, 300)
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
	elif velocity.x < 0:
		sprite.flip_h = true
		armSprite.flip_h = true

	#play run or idle animation
	if velocity.length() > 0:
		sprite.play("run")
		sprite.speed_scale = velocity.length() / maxSpeed * 2.0
	else:
		sprite.play("idle")
		sprite.speed_scale = 1.0
