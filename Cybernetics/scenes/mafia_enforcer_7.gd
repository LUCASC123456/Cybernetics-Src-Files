extends CharacterBody2D

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")
@onready var nav_agent = $NavigationAgent2D
@onready var health_bar = $EnemyHealthBar

@export var target : CharacterBody2D
@export var start_dir : String

var item_scene := preload("res://scenes/item.tscn")
var mafia_enforcer_minion_scene := preload("res://scenes/mafia_enforcer_minion.tscn")

var health : int
var speed : int
var stopping_distance : int
var total_minions : int
var minions : int
var alive : bool
var entered : bool
var damage_resistant : bool
var out_of_bounds : bool
var player_colliding : bool
var summoning : bool 
var direction : Vector2

const SUMMON_CHANCE : float = 0.25
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
#to date about this information. for this enemy, the minions convert their damage into health for this
#entity so if the health given exceed the current health bar value, assign it to the current health
#to keep the end user up to date with how much health the entity has
func _process(_delta):
	health_bar.value = health
	
	if health_bar.value < health:
		health_bar.max_value = health
		health_bar.value = health
	else:
		pass
	
#for every physics frame, this function runs
func _physics_process(_delta: float) -> void:
	#if alive, enable core physics features such as animation and simple movement
	if alive:
		$AnimatedSprite2D.animation = "run"
		#if enetered, enable all physics features such changing direction to the target, otherwise 
		#the entity cannot be damaged as it isn't fully entered yet
		if entered:
			damage_resistant = false
			direction = to_local(nav_agent.get_next_path_position())
			
			#if the entity isn't summoning minions, change the entities velocity based on distance
			#from the player e.g. if its distance from the player is less than the stopping distance
			#from the player, move backwards away from the player, or if the distance from the player
			#is the stopping distance then stop, if the distance from the player is greater than the
			#stopping distance move forwards towards the player as again, this entity does not directly
			#damage the player, in any other cast the speed is 0 because when the entity is summoniug
			#it is stationary in order to balance the game
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
				speed = 0
			
			#teleport the entity to the centre of the current level to prevent them from going out
			#of bounds
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

#everytime the summon cooldown timer finishes, check for certain conditions such as being alive 
#and entered and if these are met, there is a 25% chance that the summon timer will start and the
#entity will begin summoning enemies by picking a select number and summoning until it reaches that
#number in order to make the game more challanging for the player
func _on_summon_cool_down_timer_timeout():
	if alive and entered:
		var probability = randf()
		if probability < SUMMON_CHANCE:
			summoning = true
			total_minions = randi_range(5, 10)
			minions = 0
			
			$SummonTimer.start()
			$SummonCoolDownTimer.stop()
		else:
			pass
	else:
		pass

#every time the summon timer finishes, summon a minions by incrementing the minion count and making
#sure the number of minions is less than the total minions, if so then instantiate a minion scene in
#a random quadrant based on the entities position/origin, otherwise stop summoning to prevent the summoning
#from never ending to balance the game
func _on_summon_timer_timeout(): 
	minions += 1
	
	if minions <= total_minions:
		var mafia_enforcer_minion = mafia_enforcer_minion_scene.instantiate()
		mafia_enforcer_minion.central_spawn_point = global_position
		
		var probability = randf()
		
		if probability > 0.75:
			mafia_enforcer_minion.global_position = Vector2(position.x + randi_range(50, 100), position.y + randi_range(50, 100))
		elif probability <= 0.75 and probability > 0.5:
			mafia_enforcer_minion.global_position = Vector2(position.x - randi_range(50, 100), position.y - randi_range(50, 100))
		elif probability <= 0.5 and probability > 0.25:
			mafia_enforcer_minion.global_position = Vector2(position.x + randi_range(50, 100), position.y - randi_range(50, 100))
		elif probability <= 0.25:
			mafia_enforcer_minion.global_position = Vector2(position.x - randi_range(50, 100), position.y + randi_range(50, 100))
		else:
			pass
		
		main.add_child(mafia_enforcer_minion)
		mafia_enforcer_minion.add_to_group("minions")
		mafia_enforcer_minion.creator = self
	else:
		summoning = false
		total_minions = 0
		minions = 0
		
		$SummonTimer.stop()
		$SummonCoolDownTimer.start()

#when the player enters the entities area2d region, deal no damage as this entity does not directly
#damage the player
func _on_area_2d_body_entered(_body):
	player_colliding = true

#when the player exits the entities area2d region, nothing reguarding damage changes as as this entity
#does not directly damage the player
func _on_area_2d_body_exited(_body):
	player_colliding = false

#when the entity dies, alive is disabled to disable all physics processes, all animations and timers
#are stopped, and an enemy killed signal is emitted to tell the game the entity is dead and to overall
#stop the entity from doing or affecting anything as a whole
func die():
	z_index = 1
	collision_layer = 0
	alive = false
	$TrackTimer.stop()
	$SummonCoolDownTimer.stop()
	$SummonTimer.stop()
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
