extends CharacterBody2D

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

@export var target: Node2D = null

var item_scene := preload("res://scenes/item.tscn")

var health : int
var speed : int
var alive : bool
var entered : bool
var out_of_bounds : bool
var damage_resistant : bool
var player_colliding : bool
var direction : Vector2
var central_spawn_point : Vector2
var probability : float
const BASIC_DROP_CHANCE : float = 0.75

func _ready() -> void:
	target = player
	make_path()
	alive = true
	entered = false
	out_of_bounds = true
	visible = false
	health = 150
	speed = 0
	main.enemies_left += 1

func _on_entrance_timer_timeout():
	entered = true

func _process(_delta):
	if alive:
		if out_of_bounds:
			probability = randf()
			
			if probability > 0.75:
				position = Vector2(central_spawn_point.x + randi_range(50, 100),central_spawn_point.y + randi_range(50, 100))
			elif probability <= 0.75 and probability > 0.5:
				position = Vector2(central_spawn_point.x - randi_range(50, 100), central_spawn_point.y - randi_range(50, 100))
			elif probability <= 0.5 and probability > 0.25:
				position = Vector2(central_spawn_point.x + randi_range(50, 100), central_spawn_point.y - randi_range(50, 100))
			elif probability <= 0.25:
				position = Vector2(central_spawn_point.x - randi_range(50, 100), central_spawn_point.y + randi_range(50, 100))
		else:
			if entered == false and $EntranceTimer.is_stopped():
				$EntranceTimer.start()
	else:
		pass

func _physics_process(_delta: float) -> void:
	if alive:
		$AnimatedSprite2D.animation = "run"
		if entered:
			speed = 150
			visible = true
			damage_resistant = false
			direction = to_local(nav_agent.get_next_path_position())
			
			if out_of_bounds:
				if main.levels[2]:
					position = Vector2(3216,1624)
				elif main.levels[3]:
					position = Vector2(7128,1632)
			else:
				pass
		else:
			speed = 0
			visible = false
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
		main.hit_player_7()
		$HitTimer.start()
	else:
		pass
		
func _on_hit_timer_timeout():
	main.hit_player_7()

func _on_area_2d_body_exited(_body):
	player_colliding = false
	$HitTimer.stop()

func die():
	z_index = 1
	collision_layer = 0
	alive = false
	$HitTimer.stop()
	$TrackTimer.stop()
	$AnimatedSprite2D.stop()
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
