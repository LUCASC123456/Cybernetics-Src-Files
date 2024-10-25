extends RayCast2D

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")
@onready var game_over = get_node("/root/Main/GameOver")

#boolean that defines whether a laser will generate or not by tweening a laser and setting the 
#physics process to true or false in order to have a laser ability
var is_casting: bool = false :
	set(value): 
		is_casting = value
		
		if is_casting:
			appear()
		else:
			disapear()
		
		set_physics_process(is_casting)

#making the laser beam length 0 as well as making sure the laser beam isn't casting when the node 
#enters the tree to prevent casting as soon as the raycast enters the tree
func _ready():
	$Line2D.points[1] = Vector2.ZERO
	is_casting = false

#works by updating the cast point to the target position each frame and checks whether the raycast
#is colliding to which certain raycasts behaviours will follow if true, where the laser will endlessly
#extend by assign the cast point to the raycast collision point, if the raycast isn't collidng, extend
#to length 5000. finish off by updating the target pos by assigning the cast point to the target point to
#actually simulate this functionality on the raycast as remember, the cast point is assigned the target 
#position every frame all for realistic lazer functionality
func _process(_delta):
	var cast_point_1 := target_position
	force_raycast_update()
	
	if is_colliding():
		cast_point_1 = to_local(get_collision_point())
	else:
		cast_point_1.x = 5000
		
	target_position = cast_point_1
	
	is_casting = get_parent().lazer_activated

#used for damaging the player from the laser, taking away sheild and health
func hit_player_5_lazer():
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

#for the physics processing which only occurs when either the laser is activated,
#again update the cast point to the target position every physics frame, then check for collisions to
#which if the collions are against the player, deal damamge whilst starting the damage timer, in any other
#case stop the hit timers and finish off by assigning the end point of the laser or flame thrower to
#the cast point to constantly extend the line out to any potential collision points for realistic laser
#functionality
func _physics_process(_delta: float) -> void:
	var cast_point_2 := target_position
	force_raycast_update()
	
	if is_colliding():
		cast_point_2 = to_local(get_collision_point())
		if get_collider().name == "Player":
			hit_player_5_lazer()
			$HitTimer2.start()
		else:
			$HitTimer2.stop()
	else:
		$HitTimer2.stop()
	
	$Line2D.points[1] = cast_point_2

#when the hit timer finishes, deal damage to the player through the hit function in order to simulate
#realistic damage
func _on_hit_timer_2_timeout():
	hit_player_5_lazer()

#used for animating the laserbeam to tween outwards smoothly by creating a new tween and using the
#tween property function to set the width to extend to and the speed at which it will extend for a cool
#effect
func appear() -> void:
	var tween = create_tween()
	tween.tween_property($Line2D, "width", 10.0, 0.2)

#used for animating the laserbeam to tween inwards smoothly by creating a new tween and using the
#tween property function to set the width to decrease to and the speed at which it will decrease for
#a coool effect
func disapear() -> void:
	var tween = create_tween()
	tween.tween_property($Line2D, "width", 0, 0.1)
