extends CharacterBody2D

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@onready var enemy_spawner = get_node("/root/Main/EnemySpawner")

@export var target: Node2D = null
@export var start_dir : String

var item_scene := preload("res://scenes/item.tscn")
var mafia_enforcer_minion_scene := preload("res://scenes/mafia_enforcer_minion.tscn")

var health : int
var speed : int
var minion_count : int
var stopping_distance : int
var minion_total : int
var alive : bool
var entered : bool
var summoning : bool 
var damage_resistant : bool
var out_of_bounds : bool
var player_colliding : bool
var direction : Vector2
const summon_chance : float = 0.25

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
	health = 100
	speed = 100
	minion_count = 0
	stopping_distance = randi_range(200, 300)
	
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
			
			if not summoning:
				if nav_agent.distance_to_target() < stopping_distance-10:
					if $SpeedChangeTimer.is_stopped():
						$SpeedChangeTimer.start(0.1)
						speed = -100
					else:
						pass
				elif nav_agent.distance_to_target() >= stopping_distance-10 and nav_agent.distance_to_target() <= stopping_distance+10:
					if $SpeedChangeTimer.is_stopped():
						$SpeedChangeTimer.start(0.1)
						speed = 0
					else:
						pass
				elif nav_agent.distance_to_target() > stopping_distance+10:
					$SpeedChangeTimer.start(0.1)
					speed = 100
				else:
					pass
			else:
				pass
			
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

func _on_summon_check_timer_timeout():
	if alive and entered:
		var probability = randf()
		if probability < summon_chance:
			speed = 0
			minion_total = randi_range(5, 10)
			summoning = true
			$SummonTimer.start()
			$SummonCheckTimer.stop()
		else:
			pass
	else:
		pass

func _on_summon_timer_timeout(): 
	minion_count += 1
	
	if minion_count != minion_total:
		var mafia_enforcer_minion = mafia_enforcer_minion_scene.instantiate()
		mafia_enforcer_minion.central_spawn_point = global_position
		
		var probability = randf()
		
		if probability > 0.75:
			mafia_enforcer_minion.position = Vector2(position.x + randi_range(50, 100), position.y + randi_range(50, 100))
		elif probability <= 0.75 and probability > 0.5:
			mafia_enforcer_minion.position = Vector2(position.x - randi_range(50, 100), position.y - randi_range(50, 100))
		elif probability <= 0.5 and probability > 0.25:
			mafia_enforcer_minion.position = Vector2(position.x + randi_range(50, 100), position.y - randi_range(50, 100))
		elif probability <= 0.25:
			mafia_enforcer_minion.position = Vector2(position.x - randi_range(50, 100), position.y + randi_range(50, 100))
		else:
			pass
		
		main.add_child(mafia_enforcer_minion)
		mafia_enforcer_minion.add_to_group("minions")
	else:
		minion_count = 0
		summoning = false
		$SummonTimer.stop()
		$SummonCheckTimer.start()

func _on_area_2d_body_entered(_body):
	player_colliding = true

func _on_area_2d_body_exited(_body):
	player_colliding = false

func die():
	z_index = 1
	collision_layer = 0
	alive = false
	$TrackTimer.stop()
	$SummonCheckTimer.stop()
	$SummonTimer.stop()
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
