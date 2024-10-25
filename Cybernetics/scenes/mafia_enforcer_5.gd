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

const TELEPORT_CHANCE : float = 0.25
const LASERBEAM_CHANCE : float = 0.25
const BASIC_DROP_CHANCE : float = 0.75
const COMPLEX_DROP_CHANCE : float = 0.5

var minimap_icon = "enemy"
var marker_added : bool

#when the entity enters the tree, set up the fundamental core information of the entity such as setting
#the target as the player as well as enabling the alive variable to initate vertical or horizontal movement
#out of the spawn area and disabling the entered variable to prevent other functionality such as attacking
#to give the player some prep time. in this case also give this entity an index as it uses a target
#area node to see the player to which it will instantiate one when its instantiated and will have a
#corresponding index in an array of target area nodes
func _ready() -> void:
	target = player
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

#when the entrance timer finishes, enable the entered varialbe to enable certain functionality in
#_physics_process such as tracking the player
func _on_entrance_timer_timeout():
	entered = true

#constantly update the health bar value to the healh value every frame to constantly keep the user up
#to date about this information
func _process(_delta):
	health_bar.value = health

#for every physics frame, this function runs
func _physics_process(delta):
	#if alive, enable core physics features such as animation and simple movement
	if alive:
		$AnimatedSprite2D.animation = "run"
		#if enetered, enable all physics features such changing direction to the target, otherwise 
		#the entity cannot be damaged as it isn't fully entered yet
		if entered:
			los.enabled = true
			direction = to_local(nav_agent.get_next_path_position())
			
			#constantly rotate the line of sight in the players direction by adding or minusing delta
			#to the angle_to_target variable while finding the shortest rotation path to be in line
			#with the player by constantly assigning the angle_to_target variable to the global_rotation
			#of the raycast mostly so that the laser will be in line of the player to damage them
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
			
			#if the entity is teleporting, make sure it's immune to damage, invisible and stationary
			#while also ensuring they're not out of bounds by teleporting it until it's in bounds, them
			#resuming the laserbeam cooldown timer and the teleport cooldown timer so the special abilities
			#don't immediately occur afterwards. if the entity is firing the laser, only change the
			#speed to stationary for balancing. if none of the special abilities are being used
			#simply ensure the enemy is visible, non damage resistant and is moving
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
				
				#teleport the entity to the centre of the current level to prevent them from going out
				#of bounds
				if out_of_bounds:
					position = Vector2(7128,1632)
				else:
					pass
		else:
			damage_resistant = true
		
		#vector movement so the entity moves with direction and magnitude
		direction = direction.normalized()
		velocity = direction * speed 
		move_and_slide()
		
		#flip the animation if the enemy turns around for realistic movement
		if velocity.x != 0:
			$AnimatedSprite2D.flip_h = velocity.x < 0
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

#everytime the teleport cooldown timer finishes, check for certain conditions such as being alive 
#and entered and if these are met, there is a 25% change that the eleport timer will start
#and teleport, all to enable the entities teleportation abiliy to challenge the player
func _on_teleport_cool_down_timer_timeout():
	if alive and entered:
		var probability = randf()
		if probability <= TELEPORT_CHANCE:
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

#everytime the laser beam cooldown timer finishes, check for certain conditions such as being alive 
#and entered and if these are met, there is a 25% chance that the the lazerbeam timer will start which
#represents the duration for which the entity fires the lazer, all so that the entities laser ability
#can be enabled to challenge the player
func _on_lazer_beam_cool_down_timer_timeout():
	if alive and entered:
		if can_see_player:
			var probability = randf()
			if probability <= LASERBEAM_CHANCE:
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

#teleport towards the player by randomly picking a quadrant relative to the players position/origin
#point to teleport to in order to simulate teleportation functionality
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

#once the teleport timer is finished, teleport the entity so the player has time to prepare for the
#entity to teleport to it
func _on_teleport_timer_timeout():
	teleport()

#turn off the laser beam once the laser beam timer is finished so it isn't endless and that wouldn't
#be balanced
func _on_lazer_beam_timer_timeout():
	lazer_activated = false
	$LazerBeamCoolDownTimer.start()
	$TeleportCoolDownTimer.start()

#used for dealing damage to the player if the player collides with the entity
func hit_player_5():
	var damage : int
	
	#only deal damage when the player isn't using the force field ability to allow powerup functionality
	if target.force_field_activated:
		damage = 0
	else:
		damage = randi_range(10, 15)
	
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
#and if this condition is met, then check for if the entity is using any of its special abilities
#to which if it isn't deal damage to the player in order to balance the game, in either case start the
#hit timer
func _on_area_2d_body_entered(_body):
	player_colliding = true
	if alive and entered:
		if not teleport_activated and not lazer_activated:
			hit_player_5()
		else:
			pass
		
		$HitTimer.start()
	else:
		pass

#stop the hit timer and disable player colliding behaviours when the player leaves the entites area2d
#region
func _on_area_2d_body_exited(_body):
	player_colliding = false
	$HitTimer.stop()

#when the hit timer finishes, if the entity isn't using its special abilities deal damage to the player
#through the hit function in order to balance the game and simulate realistic damage
func _on_hit_timer_timeout():
	if not teleport_activated and not lazer_activated:
		hit_player_5()
	else:
		pass

#when the entity dies, alive is disabled to disable all physics processes, all animations and timers
#are stopped, and an enemy killed signal is emitted to tell the game the entity is dead and to overall
#stop the entity from doing or affecting anything as a whole
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
	if probability <= BASIC_DROP_CHANCE:
		drop_item_basic()
	else:
		probability = randf()
		if probability <= COMPLEX_DROP_CHANCE:
			drop_item_complex()
		else:
			pass

#drops a basic item such as ammo or health by instantiating the item scene and randomly picking a
#basic item so the player can gain benefits from killnig enemies
func drop_item_basic():
	var item = item_scene.instantiate()
	item.position = position
	item.item_type = randi_range(0, 2)
	main.call_deferred("add_child", item)
	item.add_to_group("items")

#drops a complex item such as a powerup by instantiating the item scene and randomly picking a
#complex item so the player can gain benefits from killnig enemies
func drop_item_complex():
	var item = item_scene.instantiate()
	item.position = position
	item.item_type = randi_range(3, 5)
	main.call_deferred("add_child", item)
	item.add_to_group("items")
