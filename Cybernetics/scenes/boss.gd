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
var can_see_player : bool 
var shooting_activated : bool
var lazer_activated : bool
var flame_thrower_activated : bool
var flying_activated : bool
var rotate_clockwise : bool
var direction : Vector2

const ACCELERATION := 100
const DECELERATION := 100

var minimap_icon = "enemy"
var marker_added : bool

#when the boss enters the tree, set up the fundamental core information of the boss such as setting
#the target as the player as well as enabling the alive variable to initate movement and disabling
#the entered variable to prevent other functionality such as attacking to give the player some prep time
func _ready():
	target = player
	alive = true
	entered = false
	health = 500
	speed = 0

#when the entrance timer finishes, enable the entered varialbe to enable certain functionality in
#_physics_process such as tracking the player
func _on_entrance_timer_timeout():
	entered = true

#constantly update the health bar value to the healh value every frame to constantly keep the user up
#to date about this information
func _process(_delta):
	health_bar.value = health

func _physics_process(delta):
	#if alive, enable core physics features such as animation and simple movement
	if alive:
		$RotatingSection/AnimatedSprite2D.animation = "run"
		#if enetered, enable all physics features, otherwise the entity cannot be damaged as it isn't
		#fully entered yet
		if entered:
			lof.enabled = true
			lof_2.enabled = true
			lof_3.enabled = true
			lof_4.enabled = true
			damage_resistant = false
			
			#if the entity is shooting bullets, firing lasers or firing flame throwers, set the speed
			#don't change the direction processing, keep the speed as 0, and rotate the entity by
			#constantly incrementing or minusing delta to the global rotation based on whether the
			#entity is rotation clocksise or anti clockwise all for allowing these special attacks to
			#challenge the player
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
				#if the entity is flying, wait for 1 second with speed 0 in order for a takeoff effect
				#then if the player comes within a certain angle either side of the global rotation
				#of the entity, change the direction to the direction the entity is facing based on
				#global rotation and accelerate up to speed 300, otherwise decelerate to 0. in the other
				#case, change the direction back to navigation agent based and accelerate to speed 300
				#all for a realistic depiction of flying and to challenge the player as the max speed
				#is greater than that of the player
				if flying_activated:
					if $AbilityTimer.time_left > $AbilityTimer.wait_time-1:
						direction = to_local(nav_agent.get_next_path_position())
						speed = 0
					else:
						if can_see_player:
							if angle_to_target >= global_position.direction_to(target.global_position).angle()-PI/6 and angle_to_target <= global_position.direction_to(target.global_position).angle()+PI/6:
								direction = Vector2(cos(angle_to_target), sin(angle_to_target))
								
								if speed < 300:
									speed += ACCELERATION * delta
								else:
									speed = 300
							else: 
								if speed > 0:
									speed -= DECELERATION * delta
								else:
									speed = 0
						else:
							direction = to_local(nav_agent.get_next_path_position())
							
							if speed < 300:
								speed += ACCELERATION * delta
							else:
								speed = 300
				else:
					#if none of the powerups are activated, then change the direction back to normal
					#and accelerate or decelerate to speed 75 whether above or below in speed, also
					#restart the ability cooldown timer for an overall break between abilities and overall 
					#to simulate realistic movement
					direction = to_local(nav_agent.get_next_path_position())
					
					if speed < 75:
						speed += ACCELERATION * delta
					elif speed > 75:
						speed -= ACCELERATION * delta
					else:
						speed = 75
					
					if $AbilityCoolDownTimer.is_stopped():
						$AbilityCoolDownTimer.start(randi_range(5, 10))
				
				#if the player is in the entity vision area, constantly find the shortest rotation 
				#in radians for the entity to face the player as in this case the entity is moving in 
				#the direction it's facing, by constantly adding or minusing delta from angle to target
				#then assigning angle_to_target to global rotation, if the entity is facing the player,
				#simply pass all for a realistic depiction of flying
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
					#if the player is not in the entities vision region, simply rotate to face in the
					#direction it is moving based on the navigation agent 2d the entity by constantly 
					#adding or minusing delta to the angle_to_target variable then constantly
					#assigning it to the entities global rotation by finding the rotation in radians
					#to face in this desired direction for a realistic depiction of movement
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
			
			#teleport the entity to the centre of the current level to prevent them from going out
			#of bounds
			if out_of_bounds:
				position = Vector2(8112,4968)
			else:
				pass
		else:
			damage_resistant = true
		
		direction = direction.normalized()
		velocity = direction * speed
		move_and_slide()
	else:
		pass

#generate the closest path towards the player using navigation agent 2d so the entity can get to the
#player asap
func make_path():
	nav_agent.target_position = target.global_position

#used to generate the path every time the track timer goes timeout which is about every 0.1 seconds
#for quickly updating the shortest path
func _on_track_timer_timeout():
	make_path()

#runs everytime the ability cooldown timer finishes, firstly checks that certain conditions are met
#such as the entity is alive, entered and the player is within proximity to the entity. if these are
#met then randomly pick a power up to use e.g. shooting or laser and start its duration timer
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

#when the ability timer finishes, disable the ability and stop any timers where necessary to go back
#to normal for a period of time in order to balance the game
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

#since there are 4 raycasts around the boss, 4 bullet scenes have to be instantiated as well as
#have their base position and rotation set so they have a source and travel in the correct direction
func shoot():
	if enemy_bullet:
		var bullet : Node2D = enemy_bullet.instantiate()
		bullet.add_to_group("bullets")
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = lof.global_position
		bullet.global_rotation = randf_range(lof.global_rotation+PI/60, lof.global_rotation-PI/60)
		
		var bullet_2 : Node2D = enemy_bullet.instantiate()
		bullet_2.add_to_group("bullets")
		get_tree().current_scene.add_child(bullet_2)
		bullet_2.global_position = lof_2.global_position
		bullet_2.global_rotation = randf_range(lof_2.global_rotation+PI/60, lof_2.global_rotation-PI/60)
		bullet_2.speed = -bullet_2.speed
		
		var bullet_3 : Node2D = enemy_bullet.instantiate()
		bullet_3.add_to_group("bullets")
		get_tree().current_scene.add_child(bullet_3)
		bullet_3.global_position = lof_3.global_position
		bullet_3.global_rotation = randf_range(lof_3.global_rotation+PI/60, lof_3.global_rotation-PI/60)
		
		var bullet_4 : Node2D = enemy_bullet.instantiate()
		bullet_4.add_to_group("bullets")
		get_tree().current_scene.add_child(bullet_4)
		bullet_4.global_position = lof_4.global_position
		bullet_4.global_rotation = randf_range(lof_4.global_rotation+PI/60, lof_4.global_rotation-PI/60)
		bullet_4.speed = -bullet_4.speed

#run the shoot function every time a bullet is fired
func _on_shot_timer_timeout():
	shoot()

#runs every time the missile timer finishes by firstly making sure the entity isn't using any ohter
#projectile powerups (for balancing the game difficulty) and if this condition is met, instantiate a
#missile scene by setting it's direction based on rotation and it's origin position so it functions
#like an actual missile 
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

#used for dealing damage to the player if the player collides with the entity
func hit_player_10():
	var damage : int
	
	#only deal damage when the player isn't using the force field ability to allow powerup functionality
	if target.force_field_activated:
		damage = 0
	else:
		damage = randi_range(20, 25)
	
	#take away sheild first before taking away health as that's the purpose of sheild
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
	
	#minus the credits currently earned by the player during gameplay by minusing it by the damage
	#to make credits more difficult to earn for balance
	if main.credits_earned > 0:
		main.credits_earned -= damage
		if main.credits_earned <= 0:
			main.credits_earned = 0
		else:
			pass
	else:
		pass
	
	#if the player health is 0 after the damage, pause the game and show the game overscreen displaying
	#the stats
	if target.health <= 0:
		get_tree().paused = true
		game_over.show()
		game_over.display_stats()
	else:
		pass

#when the player enters the entities area2d region, firstly make sure the entity is alive and entered
#and if this condition is met, deal damage to the player then start the hit timer in order to challenge
#the player
func _on_area_2d_body_entered(_body):
	if alive and entered:
		hit_player_10()
		$HitTimer.start()
	else:
		pass

#when the hit timer finishes, deal damage to the player through the hit function in order to simulate
#realistic damage
func _on_hit_timer_timeout():
	hit_player_10()

#stop the hit timer when the player leaves the entites area2d region so the player doesn't constant
#lose health when they lead the entities area2d region
func _on_area_2d_body_exited(_body):
	$HitTimer.stop()

#when the entity dies, alive is disabled to disable all physics processes, all animations and timers
#are stopped, and an enemy killed signal is emitted to tell the game the entity is dead and to overall
#stop the entity from doing or affecting anything as a whole
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
