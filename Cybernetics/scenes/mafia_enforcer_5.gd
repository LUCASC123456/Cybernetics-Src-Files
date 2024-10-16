extends CharacterBody2D

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@onready var los = $LineOfSight

@export var target: Node2D = null
@export var start_dir : String

var item_scene := preload("res://scenes/item.tscn")

var health : int
var speed : int 
var i : int
var alive : bool
var entered : bool
var out_of_bounds : bool
var player_colliding : bool
var damage_resistant : bool
var teleport_activated : bool
var lazer_activated : bool
var teleported : bool
var lazer_reach : bool
var direction : Vector2
var probability : float
var angle_to_target: float
const BASIC_DROP_CHANCE : float = 0.75
const TELEPORT_CHANCE : float = 0.25
const LAZERBEAM_CHANCE : float = 0.25

func _ready() -> void:
	target = player
	make_path()
	alive = true
	entered = false
	out_of_bounds = true
	health = 100
	speed = 100
	i = int(name.lstrip("MafiaEnforcer5"))
	
	var dist = target.position - position
	if start_dir == "horizontal":
		direction.x = dist.x
		direction.y = 0
	elif start_dir == "vertical":
		direction.x = 0
		direction.y = dist.y

func _on_entrance_timer_timeout():
	entered = true

func _physics_process(delta):
	if alive:
		$AnimatedSprite2D.animation = "run"
		if entered:
			los.enabled = true
			direction = to_local(nav_agent.get_next_path_position())
			
			if angle_to_target == global_position.direction_to(target.global_position).angle():
				pass
			else:
				if global_position.direction_to(target.global_position).angle() >= 0 and global_position.direction_to(target.global_position).angle() < PI/2:
					if angle_to_target >= 0 and angle_to_target < PI/2:
						if angle_to_target < global_position.direction_to(target.global_position).angle():
							angle_to_target += delta/1.5
						elif angle_to_target > global_position.direction_to(target.global_position).angle():
							angle_to_target -= delta/1.5
					elif angle_to_target >= PI/2 and angle_to_target <= PI:
						angle_to_target -= delta/1.5
					elif angle_to_target >= -PI and angle_to_target <= -PI/2:
						if angle_to_target < -PI + global_position.direction_to(target.global_position).angle():
							angle_to_target -= delta/1.5
							if angle_to_target < -PI:
								angle_to_target = PI 
						elif angle_to_target > -PI + global_position.direction_to(target.global_position).angle():
							angle_to_target += delta/1.5
					elif angle_to_target > -PI/2 and angle_to_target < 0:
						angle_to_target += delta/1.5
				elif global_position.direction_to(target.global_position).angle() >= PI/2 and global_position.direction_to(target.global_position).angle() <= PI:
					if angle_to_target >= 0 and angle_to_target < PI/2:
						angle_to_target += delta/1.5
					elif angle_to_target >= PI/2 and angle_to_target <= PI:
						if angle_to_target < global_position.direction_to(target.global_position).angle():
							angle_to_target += delta/1.5
						elif angle_to_target > global_position.direction_to(target.global_position).angle():
							angle_to_target -= delta/1.5
					elif angle_to_target >= -PI and angle_to_target <= -PI/2:
						angle_to_target -= delta/1.5
						if angle_to_target < -PI:
							angle_to_target = PI 
					elif angle_to_target > -PI/2 and angle_to_target < 0:
						if angle_to_target < -PI + global_position.direction_to(target.global_position).angle():
							angle_to_target -= delta/1.5
						elif angle_to_target > -PI + global_position.direction_to(target.global_position).angle():
							angle_to_target += delta/1.5
				elif global_position.direction_to(target.global_position).angle() >= -PI and global_position.direction_to(target.global_position).angle() <= -PI/2:
					if angle_to_target >= 0 and angle_to_target < PI/2:
						if angle_to_target < global_position.direction_to(target.global_position).angle() + PI:
							angle_to_target -= delta/1.5
						elif angle_to_target > global_position.direction_to(target.global_position).angle() + PI:
							angle_to_target += delta/1.5
					elif angle_to_target >= PI/2 and angle_to_target <= PI:
						angle_to_target += delta/1.5
						if angle_to_target > PI:
							angle_to_target = -PI 
					elif angle_to_target >= -PI and angle_to_target <= -PI/2:
						if angle_to_target < global_position.direction_to(target.global_position).angle():
							angle_to_target += delta/1.5
						elif angle_to_target > global_position.direction_to(target.global_position).angle():
							angle_to_target -= delta/1.5
					elif angle_to_target > -PI/2 and angle_to_target < 0:
						angle_to_target -= delta/1.5
				elif global_position.direction_to(target.global_position).angle() > -PI/2 and global_position.direction_to(target.global_position).angle() < 0:
					if angle_to_target >= 0 and angle_to_target < PI/2:
						angle_to_target -= delta/1.5
					elif angle_to_target >= PI/2 and angle_to_target <= PI:
						if angle_to_target < global_position.direction_to(target.global_position).angle() + PI:
							angle_to_target -= delta/1.5
						elif angle_to_target > global_position.direction_to(target.global_position).angle() + PI:
							angle_to_target += delta/1.5
							if angle_to_target > PI:
								angle_to_target = -PI
					elif angle_to_target >= -PI and angle_to_target <= -PI/2:
						angle_to_target += delta/1.5
					elif angle_to_target > -PI/2 and angle_to_target < 0:
						if angle_to_target < global_position.direction_to(target.global_position).angle():
							angle_to_target += delta/1.5
						elif angle_to_target > global_position.direction_to(target.global_position).angle():
							angle_to_target -= delta/1.5
							
			los.global_rotation = angle_to_target
			
			if teleport_activated:
				damage_resistant = true
				if teleported:
					if out_of_bounds:
						teleport()
					else:
						speed = 100
						visible = true
						teleported = false
						teleport_activated = false
						$LazerBeamChanceTimer.start()
						$TeleportChanceTimer.start()
				else:
					pass
			else:
				damage_resistant = false
				
				if out_of_bounds:
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

func _on_teleport_chance_timer_timeout():
	if alive and entered:
		probability = randf()
		if probability <= TELEPORT_CHANCE:
			if lazer_activated == false:
				speed = 0
				visible = false
				teleport_activated = true
				$TeleportTimer.start()
				$TeleportChanceTimer.stop()
				$LazerBeamChanceTimer.stop()
			else:
				pass
		else:
			pass
	else:
		pass

func _on_lazer_beam_chance_timer_timeout():
	if alive and entered:
		if lazer_reach:
			probability = randf()
			if probability <= LAZERBEAM_CHANCE:
				if teleport_activated == false:
					speed = 0
					lazer_activated = true
					$LazerBeamTimer.start()
					$LazerBeamChanceTimer.stop()
					$TeleportChanceTimer.stop()
				else:
					pass
			else:
				pass
		else:
			pass
	else:
		pass

func teleport():
	probability = randf()
	if probability > 0.75:
		position = Vector2(target.global_position.x + randi_range(100, 300), target.global_position.y + randi_range(100, 300))
	elif probability <= 0.75 and probability > 0.5:
		position = Vector2(target.global_position.x - randi_range(100, 300), target.global_position.y - randi_range(100, 300))
	elif probability <= 0.5 and probability > 0.25:
		position = Vector2(target.global_position.x + randi_range(100, 300), target.global_position.y - randi_range(100, 300))
	elif probability <= 0.25:
		position = Vector2(target.global_position.x - randi_range(100, 300), target.global_position.y + randi_range(100, 300))

func _on_teleport_timer_timeout():
	teleport()
	teleported = true

func _on_lazer_beam_timer_timeout():
	speed = 100
	lazer_activated = false
	$LazerBeamChanceTimer.start()
	$TeleportChanceTimer.start()

func _on_area_2d_body_entered(_body):
	player_colliding = true
	if alive and entered:
		if speed == 100:
			main.hit_player_5()
		$HitTimer.start()
	else:
		pass

func _on_area_2d_body_exited(_body):
	player_colliding = true
	$HitTimer.stop()

func _on_hit_timer_timeout():
	if speed == 100:
		main.hit_player_5()
	else:
		pass

func die():
	z_index = 1
	collision_layer = 0
	alive = false
	los.enabled = false
	lazer_reach = false
	lazer_activated = false
	teleport_activated = false
	$HitTimer.stop()
	$TrackTimer.stop()
	$TeleportChanceTimer.stop()
	$TeleportTimer.stop()
	$LazerBeamChanceTimer.stop()
	$LazerBeamTimer.stop()
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.animation = "dead"
	$EnemyHealthBar.hide()
	main.enemy_killed.emit()
	main.target_area_nodes[i].draw_target_area(global_position)
	
	if randf() <= BASIC_DROP_CHANCE:
		drop_item()

func drop_item():
	var item = item_scene.instantiate()
	item.position = position
	item.item_type = randi_range(0, 1)
	main.call_deferred("add_child", item)
	item.add_to_group("items")
