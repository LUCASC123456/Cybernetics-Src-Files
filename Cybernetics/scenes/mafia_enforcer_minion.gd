extends CharacterBody2D

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")
@onready var game_over = get_node("/root/Main/GameOver")
@onready var nav_agent = $NavigationAgent2D
@onready var health_bar = $EnemyHealthBar

@export var target : CharacterBody2D
@export var creator : CharacterBody2D

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

const basic_drop_chance : float = 0.75
const complex_drop_chance : float = 0.5

var minimap_icon = "enemy"
var marker_added : bool

func _ready() -> void:
	target = player
	make_path()
	alive = true
	entered = false
	out_of_bounds = true
	visible = false
	health = 100
	speed = 0
	main.enemies_left += 1

func _on_entrance_timer_timeout():
	entered = true

func _process(_delta):
	health_bar.value = health
	
	if not entered:
		if out_of_bounds:
			var probability = randf()
			
			if probability > 0.75:
				global_position = Vector2(central_spawn_point.x + randi_range(50, 100), central_spawn_point.y + randi_range(50, 100))
			elif probability <= 0.75 and probability > 0.5:
				global_position = Vector2(central_spawn_point.x - randi_range(50, 100), central_spawn_point.y - randi_range(50, 100))
			elif probability <= 0.5 and probability > 0.25:
				global_position = Vector2(central_spawn_point.x + randi_range(50, 100), central_spawn_point.y - randi_range(50, 100))
			elif probability <= 0.25:
				global_position = Vector2(central_spawn_point.x - randi_range(50, 100), central_spawn_point.y + randi_range(50, 100))
			else:
				pass
		else:
			if $EntranceTimer.is_stopped():
				$EntranceTimer.start()
			else:
				pass
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
				pass
		else:
			damage_resistant = true
			visible = true
			speed = 0
		
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

func hit_player_7():
	var damage : int
	
	if target.force_field_activated:
		damage = 0
	else:
		if main.levels[2]:
			damage = randi_range(5, 10)
		elif main.levels[3]:
			damage = randi_range(10, 15)
		else:
			pass
	
	creator.health += damage
	
	if target.sheild > 0:
		target.sheild -= damage
		
		if target.sheild < 0:
			target.health += target.sheild
			target.sheild = 0
		else:
			pass
	else:
		target.health -= damage
	
	main.damage_taken += damage
	if main.credits_earned > 0:
		main.credits_earned -= damage
		if main.credits_earned <= 0:
			main.credits_earned = 0
		else:
			pass
	else:
		pass
	
	if target.health <= 0:
		get_tree().paused = true
		game_over.show()
		game_over.display_stats()
	else:
		pass
	
func _on_area_2d_body_entered(_body):
	player_colliding = true
	if alive and entered:
		hit_player_7()
		$HitTimer.start()
	else:
		pass
		
func _on_hit_timer_timeout():
	hit_player_7()

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
	
	var probability : float
	probability = randf()
	if probability <= basic_drop_chance:
		drop_item_basic()
	else:
		probability = randf()
		if probability <= complex_drop_chance:
			drop_item_complex()
		else:
			pass
			
func drop_item_basic():
	var item = item_scene.instantiate()
	item.position = position
	item.item_type = randi_range(0, 2)
	main.call_deferred("add_child", item)
	item.add_to_group("items")

func drop_item_complex():
	var item = item_scene.instantiate()
	item.position = position
	item.item_type = randi_range(3, 5)
	main.call_deferred("add_child", item)
	item.add_to_group("items")
