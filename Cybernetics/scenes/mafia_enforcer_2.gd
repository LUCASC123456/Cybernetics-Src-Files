extends CharacterBody2D

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

@export var target: Node2D = null
@export var start_dir : String

var item_scene := preload("res://scenes/item.tscn")

var health : int
var speed : int
var alive : bool
var entered : bool
var damage_resistant : bool
var out_of_bounds : bool
var player_colliding : bool
var direction : Vector2
const BASIC_DROP_CHANCE : float = 0.75

var minimap_icon = "enemy"
var marker_added : bool

func _ready() -> void:
	target = player
	make_path()
	alive = true
	entered = false
	out_of_bounds = true
	health = 100
	speed = 200
	
	var dist = target.position - position
	if start_dir == "horizontal":
		direction.x = dist.x
		direction.y = 0
	elif start_dir == "vertical":
		direction.x = 0
		direction.y = dist.y

func _on_entrance_timer_timeout():
	entered = true

func _physics_process(_delta: float) -> void:
	if alive:
		$AnimatedSprite2D.animation = "run"
		if entered:
			damage_resistant = false
			direction = to_local(nav_agent.get_next_path_position())
			
			if out_of_bounds:
				if main.levels[0]:
					position = Vector2(384,384)
				elif main.levels[1]:
					position = Vector2(1920,384)
				elif main.levels[2]:
					position = Vector2(3216,1624)
				elif main.levels[3]:
					position = Vector2(7128,1632)
			else:
				pass
		else:
			damage_resistant = true
				
		direction = direction.normalized()
		velocity = direction * speed 
		move_and_slide()
		
		if velocity.x != 0:
			$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		pass

func make_path() -> void:
	nav_agent.target_position = target.global_position

func _on_track_timer_timeout():
	make_path()

func _on_area_2d_body_entered(_body):
	player_colliding = true
	if alive and entered:
		main.hit_player_2()
		$HitTimer.start()
	else:
		pass

func _on_hit_timer_timeout():
	main.hit_player_2()

func _on_area_2d_body_exited(_body):
	player_colliding = false
	$HitTimer.stop()

func die():
	z_index = 1
	collision_layer = 0
	alive = false
	$AnimatedSprite2D.stop()
	$HitTimer.stop()
	$TrackTimer.stop()
	$AnimatedSprite2D.animation = "dead"
	$EnemyHealthBar.hide()
	main.enemy_killed.emit()
	
	if randf() <= BASIC_DROP_CHANCE:
		drop_item()

func drop_item():
	var item = item_scene.instantiate()
	item.position = position
	item.item_type = randi_range(0, 1)
	main.call_deferred("add_child", item)
	item.add_to_group("items")
