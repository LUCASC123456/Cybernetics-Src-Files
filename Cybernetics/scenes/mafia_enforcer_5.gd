extends CharacterBody2D

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")
@onready var game_over = get_node("/root/Main/GameOver")
@onready var nav_agent = $NavigationAgent2D
@onready var health_bar = $EnemyHealthBar
@onready var los = $LineOfSight

@export var target : CharacterBody2D
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
var can_see_player : bool
var direction : Vector2
var angle_to_target: float

const teleport_chance : float = 0.25
const lazerbeam_chance : float = 0.25
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

func _process(_delta):
	health_bar.value = health

func _physics_process(delta):
	if alive:
		$AnimatedSprite2D.animation = "run"
		if entered:
			los.enabled = true
			direction = to_local(nav_agent.get_next_path_position())
			
			if angle_to_target >= global_position.direction_to(target.global_position).angle()-delta and angle_to_target <= global_position.direction_to(target.global_position).angle()+delta:
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
				visible = false
				speed = 0
				
				if $TeleportTimer.is_stopped():
					if out_of_bounds:
						teleport()
					else:
						teleport_activated = false
						$LazerBeamCoolDownTimer.start()
						$TeleportCoolDownTimer.start()
				else:
					pass
			elif lazer_activated:
				damage_resistant = false
				visible = true
				speed = 0
			else:
				damage_resistant = false
				visible = true
				speed = 100
				
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

func _on_teleport_cool_down_timer_timeout():
	if alive and entered:
		var probability = randf()
		if probability <= teleport_chance:
			if not lazer_activated:
				teleport_activated = true
				
				$TeleportTimer.start()
				$TeleportCoolDownTimer.stop()
				$LazerBeamCoolDownTimer.stop()
			else:
				pass
		else:
			pass
	else:
		pass

func _on_lazer_beam_cool_down_timer_timeout():
	if alive and entered:
		if can_see_player:
			var probability = randf()
			if probability <= lazerbeam_chance:
				if not teleport_activated:
					lazer_activated = true
					
					$LazerBeamTimer.start(randi_range(5, 10))
					$LazerBeamCoolDownTimer.stop()
					$TeleportCoolDownTimer.stop()
				else:
					pass
			else:
				pass
		else:
			pass
	else:
		pass

func teleport():
	var probability = randf()
	
	if probability > 0.75:
		global_position = Vector2(target.global_position.x + randi_range(100, 300), target.global_position.y + randi_range(100, 300))
	elif probability <= 0.75 and probability > 0.5:
		global_position = Vector2(target.global_position.x - randi_range(100, 300), target.global_position.y - randi_range(100, 300))
	elif probability <= 0.5 and probability > 0.25:
		global_position = Vector2(target.global_position.x + randi_range(100, 300), target.global_position.y - randi_range(100, 300))
	elif probability <= 0.25:
		global_position = Vector2(target.global_position.x - randi_range(100, 300), target.global_position.y + randi_range(100, 300))
	else:
		pass

func _on_teleport_timer_timeout():
	teleport()

func _on_lazer_beam_timer_timeout():
	lazer_activated = false
	$LazerBeamCoolDownTimer.start()
	$TeleportCoolDownTimer.start()

func hit_player_5():
	var damage : int
	
	if target.force_field_activated:
		damage = 0
	else:
		damage = randi_range(10, 15)
		
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
		if not teleport_activated and not lazer_activated:
			hit_player_5()
		$HitTimer.start()
	else:
		pass

func _on_area_2d_body_exited(_body):
	player_colliding = false
	$HitTimer.stop()

func _on_hit_timer_timeout():
	if not teleport_activated and not lazer_activated:
		hit_player_5()
	else:
		pass

func die():
	z_index = 1
	collision_layer = 0
	alive = false
	los.enabled = false
	lazer_activated = false
	teleport_activated = false
	$HitTimer.stop()
	$TrackTimer.stop()
	$TeleportCoolDownTimer.stop()
	$TeleportTimer.stop()
	$LazerBeamCoolDownTimer.stop()
	$LazerBeamTimer.stop()
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.animation = "dead"
	$EnemyHealthBar.hide()
	main.enemy_killed.emit()
	main.target_area_nodes[i].draw_target_area(global_position)
	
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
