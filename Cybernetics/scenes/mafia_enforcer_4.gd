extends CharacterBody2D

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

@export var target : Node2D = null
@export var start_dir : String

var item_scene := preload("res://scenes/item.tscn")
var can_see_player := false

signal hit_player_4

var health : int
var speed : int
var time : float
var alive : bool
var entered : bool
var damage_resistant : bool
var out_of_bounds : bool
var dashing : bool
var player_colliding : bool
var direction : Vector2
var vision_point = Vector2.ZERO
var exclusion_container : Array
const BASIC_DROP_CHANCE : float = 0.75

func _ready() -> void:
	target = player
	make_path()
	alive = true
	entered = false
	out_of_bounds = true
	health = 100
	speed = 150
	time = 1
	
	var dist = target.position - position
	if start_dir == "horizontal":
		direction.x = dist.x
		direction.y = 0
	elif start_dir == "vertical":
		direction.x = 0
		direction.y = dist.y

func _physics_process(delta):
	if alive:
		$AnimatedSprite2D.animation = "run"
		if entered:
			damage_resistant = false
			exclusion_container.clear()
			
			for i in $Area2D.get_overlapping_bodies():
				exclusion_container.append(i.get_rid())
				
			var space_state = get_world_2d().direct_space_state
			var query = PhysicsRayQueryParameters2D.create(global_transform.origin, player.global_transform.origin, 7, exclusion_container)
			var result = space_state.intersect_ray(query)
			
			if result:
				if result.collider == target:
					can_see_player = true
				else:
					can_see_player = false
				
				vision_point = result.position
				
			if dashing:
				if time < 1:
					time += delta
					speed = -3000 * (time) * (time-1)
				else:
					time = 1
					dashing = false
			else:
				pass
			
			if can_see_player:
				if time == 1:
					time = 0
					if $WaitTimer.is_stopped():
						$WaitTimer.start()
					else:
						pass
				elif time == 0:
					if $WaitTimer.is_stopped():
						dashing = true
					else:
						pass
			else:
				if time == 1 or time == 0:
					$WaitTimer.stop()
					direction = to_local(nav_agent.get_next_path_position())
					time = 1
					speed = 150
				
			if out_of_bounds:
				if main.levels[0]:
					position = Vector2(384,384)
				elif main.levels[1]:
					position = Vector2(1920,384)
				elif main.levels[2]:
					position = Vector2(3216,1624)
				elif main.levels[3]:
					position = Vector2(7128,1632)
				elif main.levels[4]:
					position = Vector2(8112,4968)
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
	
func die():
	z_index = 1
	collision_layer = 0
	alive = false
	$HitTimer.stop()
	$TrackTimer.stop()
	$WaitTimer.stop()
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.animation = "dead"
	$EnemyHealthBar.hide()
	get_parent().enemy_killed.emit()
	
	if randf() <= BASIC_DROP_CHANCE:
		drop_item()

func drop_item():
	var item = item_scene.instantiate()
	item.position = position
	item.item_type = randi_range(0, 1)
	main.call_deferred("add_child", item)
	item.add_to_group("items")

func _on_entrance_timer_timeout():
	entered = true

func _on_area_2d_body_entered(_body):
	player_colliding = true
	if alive and entered:
		hit_player_4.emit()
		$HitTimer.start()
	else:
		pass

func _on_hit_timer_timeout():
	hit_player_4.emit()

func _on_area_2d_body_exited(_body):
	player_colliding = false
	$HitTimer.stop()

func _on_track_timer_timeout():
	make_path()

func _on_wait_timer_timeout():
	direction = target.global_position - position
