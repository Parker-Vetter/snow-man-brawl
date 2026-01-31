extends CharacterBody2D
@onready var collision :CollisionShape2D = $CollisionShape2D
@onready var bulletOrigin: Marker2D = $BulletOrigin
@onready var shootTimer: Timer = $ShootTimer

@onready var main =  get_tree().get_root().get_node("MainGame")
@onready var projectile = load("res://MainGame/Scenes/projectile.tscn")

@export var maxSpeed = 100
@export var targetDistance = 150
## Shooting rate in shots per second
@export var shootDelay:float = 1

func _ready() -> void:
	shootTimer.wait_time = shootDelay
	shootTimer.start()

func _on_shoot_timer_timeout() -> void:
	shoot()

func shoot():
	var instance = projectile.instantiate()
	instance.dir = rotation - PI/2
	instance.spawnPos = position + bulletOrigin.position.rotated(rotation)
	instance.spawnRot = rotation
	instance.spinSpeed = randf_range(-300, 300)
	main.add_child.call_deferred(instance)
#
#
#func _input(event):
	#if event.is_action_pressed("Shoot"):
		#shoot()

func _physics_process(delta):
	#rotate toward the mouse
	var mousepositoion = get_local_mouse_position()
	rotation+= mousepositoion.angle() * 0.1
	
	#move toward the mouse
	var globalMouse = get_global_mouse_position()
	var distance = globalMouse.distance_to(position)
	var fromDestination = max(0, distance-targetDistance)
	var vel:Vector2 = position.direction_to(globalMouse) * fromDestination
	vel = vel.limit_length(maxSpeed)
	velocity = vel
	var collisions = move_and_collide(velocity*delta)
