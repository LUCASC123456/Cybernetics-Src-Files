extends CharacterBody2D

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")
@onready var game_over = get_node("/root/Main/GameOver")
@onready var world = get_node("/root/Main/World")
@onready var health_bar = $EnemyHealthBar

@export var target : CharacterBody2D
@export var start_dir : String

var item_scene := preload("res://scenes/item.tscn")

var health : int
var speed : int
var alive : bool
var entered : bool
var damage_resistant : bool
var player_colliding : bool
var world_colliding : bool
var can_see_player : bool
var phantom : bool
var direction : Vector2
var vision_point : Vector2

const PHANTOM_CHANCE : float = 0.66
const BASIC_DROP_CHANCE : float = 0.75
const COMPLEX_DROP_CHANCE : float = 0.5

var minimap_icon = "enemy"
var marker_added : bool

#when the entity enters the tree, set up the fundamental core information of the entity such as setting
#the target as the player as well as enabling the alive variable to initate vertical or horizontal movement
#out of the spawn area and disabling the entered variable to prevent other functionality such as attacking
#to give the player some prep time
func _ready() -> void:
	target = player
	alive = true
	entered = false
	health = 100
	speed = 150
	
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
			var exclusion_list := []
			
			#check if any bodies are overlapping the entity, ignoring the world since this entity doesn't
			#collide with it, make its line of sight ignore these by adding them to the exclusion list
			#array so the enemy sight isn't blocked when colliding with other enemies for realism
			for i in $Area2D.get_overlapping_bodies():
				if i.name != "World":
					exclusion_list.append(i.get_rid())
				else:
					pass
			
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
			direction = (target.position - position)
			
			#if the result (which is the enemy sight) is valid and collidng with the target, then
			#the entity can see the player which allows for certain functionality to occur under these
			#conditions
			if result:
				if result.collider == target:
					can_see_player = true
				else:
					can_see_player = false
				
				vision_point = result.position
			
			#if the entity is in phantom mode, make it transparent and make it damage resistance,
			#otherwise do the opposite in order to enable the entities special ability to challenge
			#the player
			if phantom:
				$AnimatedSprite2D.modulate.a = 0.5
				damage_resistant = true
			else:
				$AnimatedSprite2D.modulate.a = 1
				damage_resistant = false
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


#everytime the phantom cooldown timer finishes, check for certain conditions such as being alive 
#and entered and if these are met, there is a 66% chance that the phantom timer will start to which
#for its duration the entity will be in phantom mode, in order to enable the entities special ability
#and to make the game challenging for the player
func _on_phantom_cool_down_timer_timeout():
	if alive and entered:
		if can_see_player:
			var probability = randf()
			if probability <= PHANTOM_CHANCE:
				phantom = true
				$PhantomTimer.start()
				$PhantomCoolDownTimer.stop()
			else:
				pass
		else:
			pass
	else:
		pass

#once the phantom timer finishes, disable phantom mode as long as the entity isn't going through walls,
#restart the cooldown timer so that the phantom ability isn't endless for better balancing
func _on_phantom_timer_timeout():
	if not world_colliding:
		phantom = false
	else:
		pass
	
	$PhantomCoolDownTimer.start()

#used for dealing damage to the player if the player collides with the entity
func hit_player_6():
	var damage : int
	
	#only deal damage when the player isn't using the force field ability to allow powerup functionality
	if target.force_field_activated:
		damage = 0
	else:
		if main.levels[2]:
			damage = randi_range(10, 15)
		elif main.levels[3]:
			damage = randi_range(15, 20)
		else:
			pass
	
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
#the player, if the collider is the world, then activate phantom mode for a cool effect as well as
#to prevent the player from killing the entity in the wall as that would look strange
func _on_area_2d_body_entered(body):
	if body.name == "Player":
		player_colliding = true
		if alive and entered:
			hit_player_6()
			$HitTimer.start()
		else:
			pass
	elif body.name == "World":
		world_colliding = true
		if alive and entered:
			phantom = true
		else:
			pass
	else:
		pass

#when the hit timer finishes, deal damage to the player through the hit function in order to simulate
#realistic damage
func _on_hit_timer_timeout():
	hit_player_6()

#stop the hit timer when the player leaves the entites area2d region so the player doesn't constant
#lose health when they lead the entities area2d region. if the world leaves the entities aera2d region,
#check that the phatom timer isn't going and if true, then turn off phantom mode so that if the phantom
#timer is going, phantom mode won't stop
func _on_area_2d_body_exited(body):
	if body.name == "Player":
		player_colliding = false
		$HitTimer.stop()
	elif body.name == "World":
		world_colliding = true
		if $PhantomTimer.is_stopped():
			phantom = false
		else:
			pass
	else:
		pass

#when the entity dies, alive is disabled to disable all physics processes, all animations and timers
#are stopped, and an enemy killed signal is emitted to tell the game the entity is dead and to overall
#stop the entity from doing or affecting anything as a whole
func die():
	z_index = 1
	collision_layer = 0
	alive = false
	phantom = false
	$HitTimer.stop()
	$PhantomCoolDownTimer.stop()
	$PhantomTimer.stop()
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
