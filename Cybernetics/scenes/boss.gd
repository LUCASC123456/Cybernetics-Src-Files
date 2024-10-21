extends CharacterBody2D

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")
@onready var game_over = get_node("/root/Main/GameOver")
@onready var nav_agent := $NavigationAgent2D
@onready var health_bar = $EnemyHealthBar
@onready var lof = $RotatingSection/LineOfFire
@onready var lof_2 = $RotatingSection/LineOfFire2
@onready var lof_3 = $RotatingSection/LineOfFire3
@onready var lof_4 = $RotatingSection/LineOfFire4

@export var enemy_bullet : PackedScene
@export var enemy_missile : PackedScene
@export var target : CharacterBody2D

var item_scene := preload("res://scenes/item.tscn")

var health : int
var speed : int
var angle_to_target : float
var alive : bool
var entered : bool
var damage_resistant : bool
var out_of_bounds : bool
var player_colliding : bool
var can_see_player : bool 
var shooting_activated : bool
var lazer_activated : bool
var flame_thrower_activated : bool
var flying_activated : bool
var rotate_clockwise : bool
var direction : Vector2

const acceleration := 100
const deceleration := 100

var minimap_icon = "enemy"
var marker_added : bool

func _ready():
	target = player
	make_path()
	alive = true
	entered = false
	health = 500
	speed = 0

func _on_entrance_timer_timeout():
	entered = true

func _process(_delta):
	health_bar.value = health

func _physics_process(delta):
	if alive:
		$RotatingSection/AnimatedSprite2D.animation = "run"
		if entered:
			lof.enabled = true
			lof_2.enabled = true
			lof_3.enabled = true
			lof_4.enabled = true
			damage_resistant = false
			
			if shooting_activated or lazer_activated or flame_thrower_activated:
				direction = to_local(nav_agent.get_next_path_position())
				speed = 0
				
				if shooting_activated:
					if $ShotTimer.is_stopped():
						$ShotTimer.start()
					else:
						pass
				else:
					pass
				
				if rotate_clockwise:
					angle_to_target += delta
					if angle_to_target >= PI:
						angle_to_target = -PI
					else:
						pass
				else:
					angle_to_target -= delta
					if angle_to_target <= -PI:
						angle_to_target = PI
					else:
						pass
			else:
				if flying_activated:
					if $AbilityTimer.time_left > $AbilityTimer.wait_time-1:
						direction = to_local(nav_agent.get_next_path_position())
						speed = 0
					else:
						if can_see_player:
							if angle_to_target >= global_position.direction_to(target.global_position).angle()-PI/6 and angle_to_target <= global_position.direction_to(target.global_position).angle()+PI/6:
								direction = Vector2(cos(angle_to_target), sin(angle_to_target))
								
								if speed < 300:
									speed += acceleration * delta
								else:
									speed = 300
							else:
								if speed > 0:
									speed -= deceleration * delta
								else:
									speed = 0
						else:
							direction = to_local(nav_agent.get_next_path_position())
							
							if speed < 300:
								speed += acceleration * delta
							else:
								speed = 300
				else:
					direction = to_local(nav_agent.get_next_path_position())
					
					if speed < 75:
						speed += acceleration * delta
					elif speed > 75:
						speed -= acceleration * delta
					else:
						speed = 75
						
					if $AbilityCoolDownTimer.is_stopped():
						$AbilityCoolDownTimer.start(randi_range(5, 10))
					
				if can_see_player:
					if angle_to_target >= global_position.direction_to(target.global_position).angle()-delta and angle_to_target <= global_position.direction_to(target.global_position).angle()+delta:
						pass
					else:
						if global_position.direction_to(target.global_position).angle() >= 0 and global_position.direction_to(target.global_position).angle() < PI/2:
							if angle_to_target >= 0 and angle_to_target < PI/2:
								if angle_to_target < global_position.direction_to(target.global_position).angle():
									angle_to_target += delta
								elif angle_to_target > global_position.direction_to(target.global_position).angle():
									angle_to_target -= delta
							elif angle_to_target >= PI/2 and angle_to_target <= PI:
								angle_to_target -= delta
							elif angle_to_target >= -PI and angle_to_target <= -PI/2:
								if angle_to_target < -PI + global_position.direction_to(target.global_position).angle():
									angle_to_target -= delta
									if angle_to_target < -PI:
										angle_to_target = PI 
								elif angle_to_target > -PI + global_position.direction_to(target.global_position).angle():
									angle_to_target += delta
							elif angle_to_target > -PI/2 and angle_to_target < 0:
								angle_to_target += delta
						elif global_position.direction_to(target.global_position).angle() >= PI/2 and global_position.direction_to(target.global_position).angle() <= PI:
							if angle_to_target >= 0 and angle_to_target < PI/2:
								angle_to_target += delta
							elif angle_to_target >= PI/2 and angle_to_target <= PI:
								if angle_to_target < global_position.direction_to(target.global_position).angle():
									angle_to_target += delta
								elif angle_to_target > global_position.direction_to(target.global_position).angle():
									angle_to_target -= delta
							elif angle_to_target >= -PI and angle_to_target <= -PI/2:
								angle_to_target -= delta
								if angle_to_target < -PI:
									angle_to_target = PI 
							elif angle_to_target > -PI/2 and angle_to_target < 0:
								if angle_to_target < -PI + global_position.direction_to(target.global_position).angle():
									angle_to_target -= delta
								elif angle_to_target > -PI + global_position.direction_to(target.global_position).angle():
									angle_to_target += delta
						elif global_position.direction_to(target.global_position).angle() >= -PI and global_position.direction_to(target.global_position).angle() <= -PI/2:
							if angle_to_target >= 0 and angle_to_target < PI/2:
								if angle_to_target < global_position.direction_to(target.global_position).angle() + PI:
									angle_to_target -= delta
								elif angle_to_target > global_position.direction_to(target.global_position).angle() + PI:
									angle_to_target += delta
							elif angle_to_target >= PI/2 and angle_to_target <= PI:
								angle_to_target += delta
								if angle_to_target > PI:
									angle_to_target = -PI 
							elif angle_to_target >= -PI and angle_to_target <= -PI/2:
								if angle_to_target < global_position.direction_to(target.global_position).angle():
									angle_to_target += delta
								elif angle_to_target > global_position.direction_to(target.global_position).angle():
									angle_to_target -= delta
							elif angle_to_target > -PI/2 and angle_to_target < 0:
								angle_to_target -= delta
						elif global_position.direction_to(target.global_position).angle() > -PI/2 and global_position.direction_to(target.global_position).angle() < 0:
							if angle_to_target >= 0 and angle_to_target < PI/2:
								angle_to_target -= delta
							elif angle_to_target >= PI/2 and angle_to_target <= PI:
								if angle_to_target < global_position.direction_to(target.global_position).angle() + PI:
									angle_to_target -= delta
								elif angle_to_target > global_position.direction_to(target.global_position).angle() + PI:
									angle_to_target += delta
									if angle_to_target > PI:
										angle_to_target = -PI
							elif angle_to_target >= -PI and angle_to_target <= -PI/2:
								angle_to_target += delta
							elif angle_to_target > -PI/2 and angle_to_target < 0:
								if angle_to_target < global_position.direction_to(target.global_position).angle():
									angle_to_target += delta
								elif angle_to_target > global_position.direction_to(target.global_position).angle():
									angle_to_target -= delta
				else:
					if angle_to_target >= direction.angle()-delta and angle_to_target <= direction.angle()+delta:
						pass
					else:
						if direction.angle() >= 0 and direction.angle() < PI/2:
							if angle_to_target >= 0 and angle_to_target < PI/2:
								if angle_to_target < direction.angle():
									angle_to_target += delta
								elif angle_to_target > direction.angle():
									angle_to_target -= delta
							elif angle_to_target >= PI/2 and angle_to_target <= PI:
								angle_to_target -= delta
							elif angle_to_target >= -PI and angle_to_target <= -PI/2:
								if angle_to_target < -PI + direction.angle():
									angle_to_target -= delta
									if angle_to_target < -PI:
										angle_to_target = PI 
								elif angle_to_target > -PI + direction.angle():
									angle_to_target += delta
							elif angle_to_target > -PI/2 and angle_to_target < 0:
								angle_to_target += delta
						elif direction.angle() >= PI/2 and direction.angle() <= PI:
							if angle_to_target >= 0 and angle_to_target < PI/2:
								angle_to_target += delta
							elif angle_to_target >= PI/2 and angle_to_target <= PI:
								if angle_to_target < direction.angle():
									angle_to_target += delta
								elif angle_to_target > direction.angle():
									angle_to_target -= delta
							elif angle_to_target >= -PI and angle_to_target <= -PI/2:
								angle_to_target -= delta
								if angle_to_target < -PI:
									angle_to_target = PI 
							elif angle_to_target > -PI/2 and angle_to_target < 0:
								if angle_to_target < -PI + direction.angle():
									angle_to_target -= delta
								elif angle_to_target > -PI + direction.angle():
									angle_to_target += delta
						elif direction.angle() >= -PI and direction.angle() <= -PI/2:
							if angle_to_target >= 0 and angle_to_target < PI/2:
								if angle_to_target < direction.angle() + PI:
									angle_to_target -= delta
								elif angle_to_target > direction.angle() + PI:
									angle_to_target += delta
							elif angle_to_target >= PI/2 and angle_to_target <= PI:
								angle_to_target += delta
								if angle_to_target > PI:
									angle_to_target = -PI 
							elif angle_to_target >= -PI and angle_to_target <= -PI/2:
								if angle_to_target < direction.angle():
									angle_to_target += delta
								elif angle_to_target > direction.angle():
									angle_to_target -= delta
							elif angle_to_target > -PI/2 and angle_to_target < 0:
								angle_to_target -= delta
						elif direction.angle() > -PI/2 and direction.angle() < 0:
							if angle_to_target >= 0 and angle_to_target < PI/2:
								angle_to_target -= delta
							elif angle_to_target >= PI/2 and angle_to_target <= PI:
								if angle_to_target < direction.angle() + PI:
									angle_to_target -= delta
								elif angle_to_target > direction.angle() + PI:
									angle_to_target += delta
									if angle_to_target > PI:
										angle_to_target = -PI
							elif angle_to_target >= -PI and angle_to_target <= -PI/2:
								angle_to_target += delta
							elif angle_to_target > -PI/2 and angle_to_target < 0:
								if angle_to_target < direction.angle():
									angle_to_target += delta
								elif angle_to_target > direction.angle():
									angle_to_target -= delta
									
			$RotatingSection.global_rotation = angle_to_target
			
			if out_of_bounds:
				position = Vector2(8112,4968)
			else:
				pass
		else:
			damage_resistant = true
		
		direction = direction.normalized()
		velocity = direction * speed
		move_and_slide()
		
		if velocity.x != 0:
			$RotatingSection/AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		pass

func make_path():
	nav_agent.target_position = target.global_position

func _on_track_timer_timeout():
	make_path()

func _on_ability_cool_down_timer_timeout():
	if alive and entered:
		if can_see_player:
			$AbilityCoolDownTimer.stop()
			var probability = randf()
			
			if probability >= 0.75:
				shooting_activated = true
				
				probability = randf()
				if probability >= 0.5:
					rotate_clockwise = true
				else:
					rotate_clockwise = false
				
				$AbilityTimer.wait_time = randi_range(5, 15)
			elif probability < 0.75 and probability >= 0.5:
				lazer_activated = true
				
				probability = randf()
				if probability >= 0.5:
					rotate_clockwise = true
				else:
					rotate_clockwise = false
				
				$AbilityTimer.wait_time = randi_range(5, 15)
			elif probability < 0.5 and probability >= 0.25:
				flame_thrower_activated = true
				
				probability = randf()
				if probability >= 0.5:
					rotate_clockwise = true
				else:
					rotate_clockwise = false
				
				$AbilityTimer.wait_time = randi_range(5, 15)
			else:
				flying_activated = true
				$AbilityTimer.wait_time = randi_range(10, 20)
			
			$AbilityTimer.start()
	else:
		pass

func _on_ability_timer_timeout():
	if shooting_activated:
		$ShotTimer.stop()
		shooting_activated = false
	elif lazer_activated:
		lazer_activated = false
	elif flame_thrower_activated:
		flame_thrower_activated = false
	elif flying_activated:
		flying_activated = false
	else:
		pass

func shoot():
	if enemy_bullet:
		var bullet : Node2D = enemy_bullet.instantiate()
		bullet.add_to_group("bullets")
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = lof.global_position
		bullet.global_rotation = lof.global_rotation
		
		var bullet_2 : Node2D = enemy_bullet.instantiate()
		bullet_2.add_to_group("bullets")
		get_tree().current_scene.add_child(bullet_2)
		bullet_2.global_position = lof_2.global_position
		bullet_2.global_rotation = lof_2.global_rotation
		bullet_2.speed = -bullet_2.speed
		
		var bullet_3 : Node2D = enemy_bullet.instantiate()
		bullet_3.add_to_group("bullets")
		get_tree().current_scene.add_child(bullet_3)
		bullet_3.global_position = lof_3.global_position
		bullet_3.global_rotation = lof_3.global_rotation
		
		var bullet_4 : Node2D = enemy_bullet.instantiate()
		bullet_4.add_to_group("bullets")
		get_tree().current_scene.add_child(bullet_4)
		bullet_4.global_position = lof_4.global_position
		bullet_4.global_rotation = lof_4.global_rotation
		bullet_4.speed = -bullet_4.speed

func _on_shot_timer_timeout():
	shoot()

func _on_missile_timer_timeout():
	if shooting_activated or lazer_activated or flame_thrower_activated:
		pass
	else:
		if enemy_missile:
			var missile : Node2D = enemy_missile.instantiate()
			missile.add_to_group("missiles")
			get_tree().current_scene.add_child(missile)
			missile.global_position = global_position
			missile.global_rotation = global_position.direction_to(target.global_position).angle()
		else:
			pass
	
	$MissileTimer.wait_time = randi_range(5, 10)

func hit_player_10():
	var damage : int
	
	if target.force_field_activated:
		damage = 0
	else:
		damage = randi_range(20, 25)
	
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
		hit_player_10()
		$HitTimer.start()
	else:
		pass

func _on_hit_timer_timeout():
	hit_player_10()

func _on_area_2d_body_exited(_body):
	player_colliding = true
	$HitTimer.stop()

func die():
	z_index = 1
	collision_layer = 0
	alive = false
	$HitTimer.stop()
	$TrackTimer.stop()
	$AbilityCoolDownTimer.stop()
	$AbilityTimer.stop()
	$ShotTimer.stop()
	$RotatingSection/AnimatedSprite2D.stop()
	$RotatingSection/AnimatedSprite2D.animation = "dead"
	main.enemy_killed.emit()
