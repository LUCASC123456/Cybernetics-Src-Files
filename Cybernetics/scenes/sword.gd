extends Area2D

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")

var swinging : bool
var swing_clockwise : bool

const SWING_INCREMENT := ((3*PI)/4)/0.25

#sets visisblity to false when entering the tree a the end user is not using it yet
func _ready():
	visible = false

#for every frame, if the sword is swingming meaning the player and pressed some input to activate the
#swinging variable, if the sword was set to swing clockwise or anti-clockwise based on which quadrant
#the mouse position was it, the sword rotation will either have radians minused or added every frame
#while also detecting collisions with enemies to deal damage and being visisble, otherwise it won't
#detect collisions and isn't visible all for realistic sword functionalty
func _process(delta):
	if swinging:
		if swing_clockwise:
			rotation += SWING_INCREMENT * delta
		else:
			rotation -= SWING_INCREMENT * delta
		
		monitoring = true
		visible = true
	else:
		monitoring = false
		visible = false

#runs when the sword collides with something, if that something is an enemy, depending on the level
#and type of enemy, pick a random amount of damage out of a range and deal it, if the enemy health is
#below 0, run the die function while if the collider is bullet, delete the bullet, if the collider is
#the world, stop the sword from swinging all to simulate realistic sword functionality
func _on_body_entered(body):
	if body.is_in_group("enemies"):
		var damage : int
		
		if body.alive:
			if body.is_in_group("mafia_enforcer"):
				if main.levels[0]:
					damage = randi_range(20, 80)
				elif main.levels[1]:
					damage = randi_range(20, 70)
				elif main.levels[2]:
					damage = randi_range(20, 60)
				elif main.levels[3]:
					damage = randi_range(20, 50)
				else:
					pass
			elif body.is_in_group("mafia_enforcer_2"):
				if main.levels[0]:
					damage = randi_range(40, 100)
				elif main.levels[1]:
					damage = randi_range(40, 90)
				elif main.levels[2]:
					damage = randi_range(40, 80)
				elif main.levels[3]:
					damage = randi_range(40, 70)
				else:
					pass
			elif body.is_in_group("mafia_enforcer_3"):
				if main.levels[0]:
					damage = randi_range(10, 60)
				elif main.levels[1]:
					damage = randi_range(10, 50)
				elif main.levels[2]:
					damage = randi_range(10, 40)
				elif main.levels[3]:
					damage = randi_range(10, 30)
				else:
					pass
			elif body.is_in_group("mafia_enforcer_4"):
				if main.levels[0]:
					damage = randi_range(20, 80)
				elif main.levels[1]:
					damage = randi_range(20, 70)
				elif main.levels[2]:
					damage = randi_range(20, 60)
				elif main.levels[3]:
					damage = randi_range(20, 50)
				else:
					pass
			elif body.is_in_group("mafia_enforcer_5"):
				if main.levels[3]:
					damage = randi_range(10, 30)
				else:
					pass
			elif body.is_in_group("mafia_enforcer_6"):
				if main.levels[2]:
					damage = randi_range(20, 60)
				elif main.levels[3]:
					damage = randi_range(20, 50)
				else:
					pass
			elif body.is_in_group("mafia_enforcer_7"):
				if main.levels[2]:
					damage = randi_range(10, 40)
				elif main.levels[3]:
					damage = randi_range(10, 30)
				else:
					pass
			elif body.is_in_group("mafia_enforcer_8"):
				if main.levels[1]:
					damage = randi_range(20, 70)
				elif main.levels[2]:
					damage = randi_range(20, 60)
				elif main.levels[3]:
					damage = randi_range(20, 50)
				else:
					pass
			elif body.is_in_group("mafia_enforcer_9"):
				if main.levels[1]:
					damage = randi_range(10, 50)
				elif main.levels[2]:
					damage = randi_range(10, 40)
				elif main.levels[3]:
					damage = randi_range(10, 30)
				else:
					pass
			elif body.is_in_group("mafia_enforcer_minion"):
				if main.levels[2]:
					damage = randi_range(40, 80)
				elif main.levels[3]:
					damage = randi_range(40, 70)
				else:
					pass
			elif body.is_in_group("boss"):
				if main.levels[4]:
					damage = randi_range(10, 20)
				else:
					pass
				
			if body.damage_resistant:
				pass
			else:
				if player.double_damage_activated:
					body.health -= 2 * damage
				else:
					body.health -= damage
				
				main.damage_inflicted += damage
				main.credits_earned += floor(damage/3)
				
				if body.health <= 0 :
					body.die()
				else:
					pass
	elif body.is_in_group("bullets"):
		body.queue_free()
	else:
		player.get_node("SwordTimer").stop()
		swinging = false
