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

const MAG_ROUNDS : int = 30
const BASIC_DROP_CHANCE : float = 0.75
const COMPLEX_DROP_CHANCE : float = 0.5

var minimap_icon = "enemy"
var marker_added : bool

#when the entity enters the tree, set up the fundamental core information of the entity such as setting
#the target as the player as well as enabling the alive variable to initate vertical or horizontal movement
#out of the spawn area and disabling the entered variable to prevent other functionality such as attacking
#to give the player some prep time. in this case, also set a stopping distance for entity when it's
#a certain distance from the player as this entity does not damage the player directly
func _ready() -> void:
	target = player
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

#when the entrance timer finishes, enable the entered varialbe to enable certain functionality in
#_physics_process such as tracking the player
func _on_entrance_timer_timeout():
	entered = true

#constantly update the health bar value to the healh value every frame to constantly keep the user up
#to date about this information
func _process(_delta):
	health_bar.value = health

#for every physics frame, this function runs
func _physics_process(_delta: float) -> void:
	#if alive, enable core physics features such as animation and simple movement
	if alive:
		$AnimatedSprite2D.animation = "run"
		#if enetered, enable all physics features such changing direction to the target, otherwise 
		#the entity cannot be damaged as it isn't fully entered yet
		if entered:
			damage_resistant = false
			var exclusion_list := []
			
			#check if any bodies are overlapping the entity, make its line of sight ignore these by
			#adding them to the exclusion list array so the enemy sight isn't blocked when colliding
			#with other enemies for realism
			for i in $Area2D.get_overlapping_bodies():
				exclusion_list.append(i.get_rid())
			
			#check if any bodies are overlapping the player, make its line of sight ignore these by
			#adding them to the exclusion list array the so the enemy sight isn't blocked by enemies
			#colliding with the player for realism
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
			
			#create variables to constantly generate a new enemy sight by settings parameters that
			#change its properties so the entity is always looking in the players direction
			var space_state = get_world_2d().direct_space_state
			var query = PhysicsRayQueryParameters2D.create(global_transform.origin, player.global_transform.origin, 7, exclusion_list)
			var result = space_state.intersect_ray(query)
			direction = to_local(nav_agent.get_next_path_position())
			
			#if the result (which is the enemy sight) is valid and collidng with the target, then
			#the entity can see the player which allows for certain functionality to occur under these
			#conditions
			if result:
				if result.collider == target:
					can_see_player = true
				else:
					can_see_player = false
					
				vision_point = result.position
			
			#if the entity can see the player, allow for it to fire bullets towards the player in order
			#to make the game challenging for the player. also change the entities velocity based on distance
			#from the player e.g. if its distance from the player is less than the stopping distance
			#from the player, move backwards away from the player, or if the distance from the player
			#is the stopping distance then stop, if the distance from the player is greater than the
			#stopping distance move forwards towards the player as this entity does not directly
			#damage the player, in any other case where it cannot see the player set its velocity back
			#to normal moving forward to simulate realistic behaviours
			if can_see_player:
				if shot_timer.is_stopped() and reload_timer.is_stopped():
					if shots < MAG_ROUNDS:
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
			
			#teleport the entity to the centre of the current level to prevent them from going out
			#of bounds
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
func make_path() -> void:
	nav_agent.target_position = target.global_position

#used to generate the path every time the track timer goes timeout which is about every 0.1 seconds
#for quickly updating the shortest path
func _on_track_timer_timeout():
	make_path()

#instantiate a bullet scene by setting up it's initial position and well as its rotation to the player
#for movement in the players general direction to make the game challenging for the player
func shoot():
	if enemy_bullet:
		var bullet: Node2D = enemy_bullet.instantiate()
		bullet.add_to_group("bullets")
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = global_position
		bullet.global_rotation = randf_range((target.global_position - global_position).angle()+PI/60,(target.global_position - global_position).angle()-PI/60)
	
	shot_timer.start()

#when other specific enemy enters the entities area2d region increment the number of bodies it's
#colliding with by one and change its stopping distance so it doesn't stop behind an enemy and constantly
#fires bullets into the back of it
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

#when other specific enemies exit the entities area2d region reduce the number of bodies it's
#colliding with by one and reset its stopping distance if the collider count is 0 so that the enemy
#changes its stopping distance to simulate realistic behaviours
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

#when the entity dies, alive is disabled to disable all physics processes, all animations and timers
#are stopped, and an enemy killed signal is emitted to tell the game the entity is dead and to overall
#stop the entity from doing or affecting anything as a whole
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
