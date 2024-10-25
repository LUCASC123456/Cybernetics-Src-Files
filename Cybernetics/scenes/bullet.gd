extends Area2D

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")
@onready var game_won = get_node("/root/Main/GameWon")

var primary_bullet_speed : int = 0
var secondary_bullet_speed : int = 0
var direction : Vector2

#selecting bullet speeds for the different guns the player is using for the primary and secondary 
#weapon so the end user gets benefit out of buying weapons
func _ready():
	if player.primary_selected_gun == "PISTOL":
		primary_bullet_speed = 750
	elif player.primary_selected_gun == "SMG":
		primary_bullet_speed = 850
	elif player.primary_selected_gun == "LMG":
		primary_bullet_speed = 1050
	elif player.primary_selected_gun == "AR":
		primary_bullet_speed = 950
	else:
		pass
	
	if player.secondary_selected_gun == "PISTOL":
		secondary_bullet_speed = 750
	elif player.secondary_selected_gun == "MP":
		secondary_bullet_speed = 850
	else:
		pass

#simulate bullet movement by adding distance every delta through velocity and rotating the bullet to 
#face in the direction of travel for realism
func _process(delta):
	if player.primary_equipped:
		position += primary_bullet_speed * direction * delta
		rotation = direction.angle()
	else:
		position += secondary_bullet_speed * direction * delta
		rotation = direction.angle()

#deleting the bullet after a certain amount of time if it hasn't hit anything to prevent lag
func _on_timer_timeout():
	queue_free()

#runs when the bullet collides with something, if that something is an enemy, depending on the level
#and type of enemy, pick a random amount of damage out of a range and deal it, if the enemy health is
#below 0, run the die function and always delete the bullet in the process in order to simulate
#realistic bullets and to allow for the player to kill the enemies
func _on_body_entered(body):
	if body.is_in_group("enemies"):
		var damage : int
		
		if body.alive:
			if body.is_in_group("mafia_enforcer"):
				if main.levels[0]:
					damage = randi_range(10, 70)
				elif main.levels[1]:
					damage = randi_range(10, 60)
				elif main.levels[2]:
					damage = randi_range(10, 50)
				elif main.levels[3]:
					damage = randi_range(10, 40)
				else:
					pass
			elif body.is_in_group("mafia_enforcer_2"):
				if main.levels[0]:
					damage = randi_range(30, 90)
				elif main.levels[1]:
					damage = randi_range(30, 80)
				elif main.levels[2]:
					damage = randi_range(30, 70)
				elif main.levels[3]:
					damage = randi_range(30, 60)
				else:
					pass
			elif body.is_in_group("mafia_enforcer_3"):
				if main.levels[0]:
					damage = randi_range(0, 50)
				elif main.levels[1]:
					damage = randi_range(0, 40)
				elif main.levels[2]:
					damage = randi_range(0, 30)
				elif main.levels[3]:
					damage = randi_range(0, 20)
				else:
					pass
			elif body.is_in_group("mafia_enforcer_4"):
				if main.levels[0]:
					damage = randi_range(10, 70)
				elif main.levels[1]:
					damage = randi_range(10, 60)
				elif main.levels[2]:
					damage = randi_range(10, 50)
				elif main.levels[3]:
					damage = randi_range(10, 40)
				else:
					pass
			elif body.is_in_group("mafia_enforcer_5"):
				if main.levels[3]:
					damage = randi_range(0, 20)
				else:
					pass
			elif body.is_in_group("mafia_enforcer_6"):
				if main.levels[2]:
					damage = randi_range(10, 50)
				elif main.levels[3]:
					damage = randi_range(10, 40)
				else:
					pass
			elif body.is_in_group("mafia_enforcer_7"):
				if main.levels[2]:
					damage = randi_range(0, 30)
				elif main.levels[3]:
					damage = randi_range(0, 20)
				else:
					pass
			elif body.is_in_group("mafia_enforcer_8"):
				if main.levels[1]:
					damage = randi_range(10, 60)
				elif main.levels[2]:
					damage = randi_range(10, 50)
				elif main.levels[3]:
					damage = randi_range(10, 40)
				else:
					pass
			elif body.is_in_group("mafia_enforcer_9"):
				if main.levels[1]:
					damage = randi_range(0, 40)
				elif main.levels[2]:
					damage = randi_range(0, 30)
				elif main.levels[3]:
					damage = randi_range(0, 20)
				else:
					pass
			elif body.is_in_group("mafia_enforcer_minion"):
				if main.levels[2]:
					damage = randi_range(30, 70)
				elif main.levels[3]:
					damage = randi_range(30, 60)
				else:
					pass
			elif body.is_in_group("boss"):
				if main.levels[4]:
					damage = randi_range(0, 10)
				else:
					pass
			
			#enemies can be damage resistant so this must not be true in order to deal damage for balance
			if body.damage_resistant:
				if body.entered:
					pass
				else:
					queue_free()
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
				
				queue_free()
	else:
		queue_free()
