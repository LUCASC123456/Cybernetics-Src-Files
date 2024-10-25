extends Area2D

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")
@onready var game_over = get_node("/root/Main/GameOver")

@export var speed: int = 950

const DIRECTION = Vector2.RIGHT

#for each frame, create a velocity variable and constantly add it to the position of the bullet which
#acts as the distance in order to simulate bullet movement
func _physics_process(delta):
	var velocity = DIRECTION.rotated(rotation) * speed * delta
	global_position += velocity

#used for damaging the player from the bullet, taking away sheild and health
func hit_player_10_bullet():
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

#when the bullets hits something, if that something is the player, deal damage while always deleting
#the bullet to simulate realistic bullet behaviours
func _on_body_entered(body):
	if body.name == "Player":
		hit_player_10_bullet()
		queue_free()
	else:
		queue_free()

#delete the bullet when after a certain amount of time if it hasn't hit anything to prevent lag
func _on_timer_timeout():
	queue_free()
