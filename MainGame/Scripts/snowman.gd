extends CharacterBody2D

@onready var pickupScene = load("res://MainGame/Scenes/pickup.tscn")

@export var maxHealth: int = 2
@export var scaleHealthByLevel = true;
@export var speed: float = 100
@export var drop_table: Array[DropTableEntry] = []
@export var number_of_drops: int = 1
@export var scaleDropsByLevel = true

var player: CharacterBody2D
var main: MainGame
var dir: float
var spawnPos: Vector2
var spawnRot: float
var spinSpeed: float
var gameData: GameData
var _internal_drop_table: Array[int] = []

var health: int
var dead: bool = false
@onready var standard_sprite: AnimatedSprite2D = $StandardSprite
@onready var ski_sprite: AnimatedSprite2D = get_node_or_null("SkiMaskSprite")
@onready var godot_mask_sprite: AnimatedSprite2D = get_node_or_null("GodotMask")
@onready var die_sprite: AnimatedSprite2D = $die
@onready var splat_sound: AudioStreamPlayer = $Splat

func _ready() -> void:
	if not player:
		print("Player not found")
		return
	global_position = spawnPos
	global_rotation = spawnRot
	health = maxHealth * (main.gameData.level if scaleHealthByLevel else 1)
	_internal_drop_table = []
	for i in range(drop_table.size()):
		for j in range(drop_table[i].chance * 100):
			_internal_drop_table.append(i)
	
func _physics_process(_delta: float) -> void:
	if not player:
		return
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	move_and_slide()
	

func take_damage(damage: int) -> void:
	if dead:
		return
	health -= damage
	if health <= 0:
		dead = true
		# stop movement and disable collisions, and remove from enemies group so it can't hurt the player during death animation
		velocity = Vector2.ZERO
		collision_layer = 0
		collision_mask = 0
		if has_node("HitBox"):
			$HitBox.monitoring = false
			$HitBox.queue_free()
		remove_from_group("enemies")
		# show death animation and play sound
		if standard_sprite:
			standard_sprite.visible = false
		if ski_sprite:
			ski_sprite.visible = false
		if godot_mask_sprite:
			godot_mask_sprite.visible = false
		die_sprite.visible = true
		die_sprite.sprite_frames.set_animation_loop("default", false)
		die_sprite.play("default")
		if splat_sound:
			splat_sound.play()
		# spawn drops immediately on death
		var drops = number_of_drops * (main.gameData.level if scaleDropsByLevel else 1)
		for i in range(drops):
			var drop = drop_table[_internal_drop_table.pick_random()]
			var pickup = pickupScene.instantiate()
			pickup.data = drop.data
			var floatAngle = randf_range(-PI, PI)
			pickup.dir = floatAngle
			pickup.spawnPos = position + Vector2(randi_range(-50, 50), randi_range(-50, 50))
			pickup.spawnRot = floatAngle
			pickup.spinSpeed = randf_range(-300, 300)
			pickup.speed = randf_range(-50, 50)
			main.add_child.call_deferred(pickup)
		gameData.kills += 1
		# call _on_die_animation_finished when animation ends
		die_sprite.connect("animation_finished", Callable(self, "_on_die_animation_finished"))


func _on_die_animation_finished(anim_name: String = "") -> void:
	queue_free()
