extends CharacterBody2D

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@onready var reload_timer = $ReloadTimer
@onready var shot_timer = $ShotTimer

@export var ENEMY_BULLET: PackedScene = null
@export var target: Node2D = null
@export var start_dir : String

var item_scene := preload("res://scenes/item.tscn")
var can_see_player := false

var health : int
var speed : int
var shot_count : int
var stopping_distance : int
var body_collider_count : int 
var alive : bool
var entered : bool
var damage_resistant : bool
var out_of_bounds : bool
var player_colliding : bool
var direction : Vector2
var vision_point = Vector2.ZERO
var exclusion_container : Array
const BASIC_DROP_CHANCE : float = 0.75

var minimap_icon = "enemy"
var marker_added : bool
var marker_removed : bool

func _ready() -> void:
	target = player
	make_path()
	alive = true
	entered = false
	out_of_bounds = true
	health = 100
	speed = 100
	shot_count = 0
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
			exclusion_container.clear()
			
			for i in $Area2D.get_overlapping_bodies():
				exclusion_container.append(i.get_rid())
			
			for i in main.get_children():
				if i is CharacterBody2D:
					if i.name != "Player":
						if i.player_colliding:
							exclusion_container.append(i.get_rid())
						else:
							pass
					else:
						pass
				else:
					pass
				
			var space_state = get_world_2d().direct_space_state
			var query = PhysicsRayQueryParameters2D.create(global_transform.origin, player.global_transform.origin, 7, exclusion_container)
			var result = space_state.intersect_ray(query)
			direction = to_local(nav_agent.get_next_path_position())
			
			if result:
				if result.collider == player:
					can_see_player = true
				else:
					can_see_player = false
					
				vision_point = result.position
			
			if can_see_player:
				if shot_timer.is_stopped() and reload_timer.is_stopped():
					if shot_count < 15:
						shoot()
						shot_count += 1
					else:
						shot_count = 0
						reload_timer.start()
				else:
					pass
				
				if nav_agent.distance_to_target() < stopping_distance-10:
					if $SpeedChangeTimer.is_stopped():
						$SpeedChangeTimer.wait_time = 0.1
						$SpeedChangeTimer.start()
						speed = -100
				elif nav_agent.distance_to_target() >= stopping_distance-10 and nav_agent.distance_to_target() <= stopping_distance+10:
					if $SpeedChangeTimer.is_stopped():
						$SpeedChangeTimer.wait_time = 0.1
						$SpeedChangeTimer.start()
						speed = 0
				elif nav_agent.distance_to_target() > stopping_distance+10:
					if $SpeedChangeTimer.is_stopped():
						$SpeedChangeTimer.wait_time = 0.1
						$SpeedChangeTimer.start()
						speed = 100
			else:
				if result.collider.is_in_group("enemies"):
					$SpeedChangeTimer.wait_time = 0.1
				else:
					$SpeedChangeTimer.wait_time = randf_range(0.5, 1)
				
				$SpeedChangeTimer.start()
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
	if ENEMY_BULLET:
		var bullet : Node2D = ENEMY_BULLET.instantiate()
		bullet.add_to_group("bullets")
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = global_position
		bullet.global_rotation = (target.global_position - global_position).angle()
	
	shot_timer.start()

func _on_area_2d_body_entered(body):
	if body.is_in_group("enemies"):
		if body != self:
			if body.is_in_group("mafia_enforcer_7") or body.is_in_group("mafia_enforcer_8") or body.is_in_group("mafia_enforcer_9"):
				body_collider_count += 1
				if stopping_distance > body.stopping_distance+50:
					stopping_distance = randi_range(200, body.stopping_distance+40)
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
	elif body.name == "Player":
		player_colliding = false
	else:
		pass

func die():
	z_index = 1
	collision_layer = 0
	alive = false
	marker_removed = true
	$ShotTimer.stop()
	$ReloadTimer.stop()
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
