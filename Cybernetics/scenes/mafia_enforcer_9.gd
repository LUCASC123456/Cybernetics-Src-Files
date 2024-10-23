extends CharacterBody2D

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")
@onready var nav_agent = $NavigationAgent2D
@onready var health_bar = $EnemyHealthBar
@onready var reload_timer = $ReloadTimer
@onready var shot_timer = $ShotTimer

@export var target : CharacterBody2D
@export var enemy_bullet : PackedScene
@export var start_dir : String

var item_scene := preload("res://scenes/item.tscn")

var health : int
var speed : int
var shots : int
var stopping_distance : int
var body_collider_count : int 
var alive : bool
var entered : bool
var damage_resistant : bool
var out_of_bounds : bool
var player_colliding : bool
var can_see_player : bool 
var direction : Vector2
var vision_point : Vector2

const mag_rounds : int = 30
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
	shots = 0
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

func _process(_delta):
	health_bar.value = health

func _physics_process(_delta: float) -> void:
	if alive:
		$AnimatedSprite2D.animation = "run"
		if entered:
			damage_resistant = false
			var exclusion_list := []
			
			for i in $Area2D.get_overlapping_bodies():
				exclusion_list.append(i.get_rid())
			
			for i in main.get_children():
				if i is CharacterBody2D:
					if i.name != "Player":
						if i.player_colliding:
							exclusion_list.append(i.get_rid())
						else:
							pass
					else:
						pass
				else:
					pass
			
			var space_state = get_world_2d().direct_space_state
			var query = PhysicsRayQueryParameters2D.create(global_transform.origin, player.global_transform.origin, 7, exclusion_list)
			var result = space_state.intersect_ray(query)
			
			direction = to_local(nav_agent.get_next_path_position())
			
			if result:
				if result.collider == target:
					can_see_player = true
				else:
					can_see_player = false
					
				vision_point = result.position
		
			if can_see_player:
				if shot_timer.is_stopped() and reload_timer.is_stopped():
					if shots < mag_rounds:
						shoot()
						shots += 1
					else:
						shots = 0
						reload_timer.start()
				else:
					pass
				
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
					if $SpeedChangeTimer.is_stopped():
						$SpeedChangeTimer.start(0.1)
						speed = 100
					else:
						pass
				else:
					pass
			else:
				if result:
					if result.collider.is_in_group("enemies"):
						$SpeedChangeTimer.start(0.1)
					else:
						$SpeedChangeTimer.start(randf_range(0.5, 1))
				else:
					$SpeedChangeTimer.start(0.1)
				
				speed = 100
				
			if out_of_bounds:
				if main.levels[1]:
					position = Vector2(1920,384)
				elif main.levels[2]:
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

func shoot():
	if enemy_bullet:
		var bullet: Node2D = enemy_bullet.instantiate()
		bullet.add_to_group("bullets")
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = global_position
		bullet.global_rotation = randf_range((target.global_position - global_position).angle()+PI/60,(target.global_position - global_position).angle()-PI/60)
	
	shot_timer.start()

func _on_area_2d_body_entered(body):
	if body.is_in_group("enemies"):
		if body != self:
			if body.is_in_group("mafia_enforcer_7") or body.is_in_group("mafia_enforcer_8") or body.is_in_group("mafia_enforcer_9"):
				body_collider_count += 1
				
				if stopping_distance > body.stopping_distance+50:
					stopping_distance = randi_range(200, body.stopping_distance+25)
				else:
					pass
			else:
				pass
		else:
			pass
	elif body.name == "Player":
		player_colliding = true
	else:
		pass

func _on_area_2d_body_exited(body):
	if body.is_in_group("enemies"):
		if body != self:
			if body.is_in_group("mafia_enforcer_7") or body.is_in_group("mafia_enforcer_8") or body.is_in_group("mafia_enforcer_9"):
				body_collider_count -= 1
				
				if body_collider_count == 0:
					stopping_distance = randi_range(200,300)
				else:
					pass
			else:
				pass
		else:
			pass
	elif body.name == "Player":
		player_colliding = false
	else:
		pass

func die():
	z_index = 1
	collision_layer = 0
	alive = false
	$ShotTimer.stop()
	$ReloadTimer.stop()
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
