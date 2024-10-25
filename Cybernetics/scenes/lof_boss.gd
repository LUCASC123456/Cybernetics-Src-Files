extends RayCast2D

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")
@onready var game_over = get_node("/root/Main/GameOver")

var burn_time : int
var burn_count : int

#boolean that defines whether a laser will generate or not by checking if the flame thrower is disabled,
#and if so or not, tweening a laser and setting the physics process to true or false in order to have
#a laser ability
var is_casting_1: bool = false :
	set(value):
		if is_casting_2:
			pass
		else:
			is_casting_1 = value
			
			if is_casting_1:
				$Line2D.default_color = Color(0,255,255,255)
				$Line2D.self_modulate = Color(0,255,255,255)
				appear()
			else:
				disapear()
				
			set_physics_process(is_casting_1)

#boolean that defines whether a flame thrower will generate or not by checking if the laser is disabled,
#and if so or not, tweening a flame thrower and setting the physics process to true or false in order
#to have a flame thrower ability
var is_casting_2: bool = false :
	set(value): 
		if is_casting_1:
			pass
		else:
			is_casting_2 = value
			
			if is_casting_2:
				$Line2D.default_color = Color(255,80,0,255)
				$Line2D.self_modulate = Color(255,80,0,255)
				appear()
			else:
				disapear()
			
			set_physics_process(is_casting_2)

#making the laser beam and flame thrower length 0 as well as prventing the laser beam and flame thrower
#aren't casting when the node enters the tree
func _ready():
	$Line2D.points[1] = global_position
	is_casting_1 = false
	is_casting_2 = false

#works by updating the cast point to the target position each frame and checks whether the raycast
#is colliding to which certain raycasts behaviours will follow if true, where the laser will endlessly
#extend by assign the cast point to the raycast collision point while any other cast will extend to a
#maximum of 500 pixels, if the raycast isn't collidng, extend to length 5000 for laser and length 500
#for any other case. finish off by assigning the cast point to the target point to actually simulate
#this functionality on the raycast as remember, the cast point is assigned the target position every frame
#for realistic laser and flame thrower functionality
func _process(_delta):
	var cast_point_1 := target_position
	force_raycast_update()
	
	if is_colliding():
		if is_casting_1:
			cast_point_1 = to_local(get_collision_point())
		else:
			if cast_point_1.x > 500:
				cast_point_1.x = 500
			else:
				cast_point_1 = to_local(get_collision_point())
	else:
		if is_casting_1:
			cast_point_1.x = 5000
		else:
			cast_point_1.x = 500
	
	target_position = cast_point_1
	
	is_casting_1 = get_parent().get_parent().lazer_activated
	is_casting_2 = get_parent().get_parent().flame_thrower_activated

#used for damaging the player from the explosion area, taking away sheild and health
func hit_player_10_lazer():
	var damage : int
	
	#only deal damage when the player isn't using the force field ability to allow powerup functionality
	if player.force_field_activated:
		damage = 0
	else:
		damage = randi_range(20, 25)
	
	#take away sheild first before taking away health as that's the purpose of sheild
	if player.sheild > 0:
		player.sheild -= damage
		
		if player.sheild < 0:
			player.health += player.sheild
			player.sheild = 0
		else:
			pass
	else:
		player.health -= damage
	
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
	if player.health <= 0:
		get_tree().paused = true
		game_over.show()
		game_over.display_stats()
	else:
		pass

func hit_player_10_flame_thrower():
	var damage : int
	
	#only deal damage when the player isn't using the force field ability to allow powerup functionality
	if player.force_field_activated:
		damage = 0
	else:
		damage = randi_range(10, 15)
	
	#take away sheild first before taking away health as that's the purpose of sheild
	if player.sheild > 0:
		player.sheild -= damage
		
		if player.sheild < 0:
			player.health += player.sheild
			player.sheild = 0
		else:
			pass
	else:
		player.health -= damage
	
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
	if player.health <= 0:
		get_tree().paused = true
		game_over.show()
		game_over.display_stats()
	else:
		pass

#for the physics processing which only occurs when either the laser or the flame thrower is activated,
#again update the cast point to the target position every physics frame, then check for collisions to
#which if the collions are against the player, deal damamge whilst starting the damage timer, where
#for the flame thrower a seperate burn timer starts to simulate the player buring of fire, in any other
#case stop the hit timers and finish off by assigning the end point of the laser or flame thrower to
#the cast point again for realistic laser beam and flame thrower functionality
func _physics_process(_delta):
	var cast_point_2 := target_position
	force_raycast_update()
	
	if is_colliding():
		cast_point_2 = to_local(get_collision_point())
		if get_collider().name == "Player":
			if is_casting_1:
				if $HitTimer2.is_stopped():
					hit_player_10_lazer()
					$HitTimer2.start()
				else:
					pass
			else:
				if $HitTimer2.is_stopped():
					hit_player_10_flame_thrower()
					$HitTimer2.start()
				else:
					pass
				
				if $BurnTimer.is_stopped():
					burn_count = 0
					burn_time = randi_range(5, 10)
					$BurnTimer.start()
				else:
					pass
		else:
			$HitTimer2.stop()
	else:
		$HitTimer2.stop()
	
	$Line2D.points[1] = cast_point_2

#when the hit timer finishes, deal damage to the player based on which ability is being used through
#the hit function in order to simulate realistic damage
func _on_hit_timer_2_timeout():
	if is_casting_1:
		hit_player_10_lazer()
	else:
		hit_player_10_flame_thrower()

#every time the burn timer finishes, deal damage to the player if the number of burns is less than
#the desired amount, otherwise stop the burn timer for a realistic fire effect
func _on_burn_timer_timeout():
	if burn_count < burn_time:
		hit_player_10_flame_thrower()
		burn_count += 1
	else:
		$BurnTimer.stop()

#used for animating the laserbeam and flame thrower to tween outwards smoothly by creating a new 
#tween and using the tween property function to set the width to extend to and the speed at which it
#will extend for a cool effect
func appear() -> void:
	var tween = create_tween()
	
	if is_casting_1:
		tween.tween_property($Line2D, "width", 10.0, 0.2)
	else:
		tween.tween_property($Line2D, "width", 15.0, 0.2)

#used for animating the laserbeam and flame thrower to tween inwards smoothly by creating a new 
#tween and using the tween property function to set the width to decrease to and the speed at which it
#will decrease for a cool effect
func disapear() -> void:
	var tween = create_tween()
	tween.tween_property($Line2D, "width", 0, 0.1)
