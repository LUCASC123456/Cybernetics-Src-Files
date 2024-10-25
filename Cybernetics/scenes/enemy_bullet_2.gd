extends Area2D

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")
@onready var game_over = get_node("/root/Main/GameOver")

@export var speed: int = 950

var area_collider_count : int
var bullet_collisions : bool

const DIRECTION = Vector2.RIGHT

#when the bullet enters the tree, set it's collisions to the enemies specifically to false to prevent
#it from immediately deleting after colliding with its source
func ready():
	bullet_collisions = false

#for each frame, create a velocity variable and constantly add it to the position of the bullet which
#acts as the distance in order to simulate bullet movement
func _physics_process(delta):
	var velocity = DIRECTION.rotated(rotation) * speed * delta
	global_position += velocity

#used for damaging the player from the bullet, taking away sheild and health
func hit_player_9():
	var damage : int
	
	#only deal damage when the player isn't using the force field ability to allow powerup functionality
	if player.force_field_activated:
		damage = 0
	else:
		if main.levels[1]:
			damage = randi_range(10, 15)
		elif main.levels[2]:
			damage = randi_range(15, 20)
		elif main.levels[3]:
			damage = randi_range(20, 25)
		else:
			pass
	
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

#when the bullets hits something, if that something is the player, deal damage while always deleting
#the bullet to simulate realistic bullet behaviours while incrementing the body collider count if
#enemy collisions are disabled to help the bullet know when to turn om enemy collisions
func _on_body_entered(body):
	if body.name == "Player":
		hit_player_9()
		queue_free()
	elif body.is_in_group("enemies"):
		if bullet_collisions:
			queue_free()
		else:
			area_collider_count += 1
	else:
		queue_free()

#when the bullet exits an enemy body specifically, reduce the number of colliding bodies by one again
#to determine when to turn on enemy collisions if the nubmer of colliding enemies is 0 so the bullet
#doesn't delete itself when generated or leaving crowds of enemies for better bullet functionality
func _on_body_exited(body):
	if body.is_in_group("enemies"):
		area_collider_count -= 1
		
		if area_collider_count == 0:
			bullet_collisions = true
		else:
			pass

#delete the bullet when after a certain amount of time if it hasn't hit anything to prevent lag
func _on_timer_timeout():
	queue_free()
