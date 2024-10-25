extends Area2D

@onready var main = get_node('/root/Main')
@onready var player = get_node("/root/Main/Player")
@onready var game_over = get_node("/root/Main/GameOver")

var area : CircleShape2D

const EXPANSION_RATE := 300

#storing the nodes collision shape in a varialbe called area to make the code look cleaner
func _ready():
	area = $CollisionShape2D.shape

#using simple math to smoothly expand the circle by adding some radius every delta using the expansion
#rate constant until the radius is 100 to simulate an explosion
func _physics_process(delta):
	if area.radius < 100:
		area.radius += EXPANSION_RATE * delta
	else:
		queue_free()

#used for damaging the player from the explosion area, taking away sheild and health
func hit_player_10_missile():
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

#when the body (player) enters the explosion area, run the attack function above to deal damage to further
#simulate the affects of an explosion
func _on_body_entered(_body):
	main.hit_player_10_missile()
