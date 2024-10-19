extends Area2D

@onready var main = get_node("/root/Main")
@onready var game_won = get_node("/root/Main/GameWon")
@onready var player = get_node("/root/Main/Player")

var speed : int = 0
var direction : Vector2

func _ready():
	if player.selected_gun == "PISTOL":
		speed = 750
	elif player.selected_gun == "SMG":
		speed = 850
	elif player.selected_gun == "LMG":
		speed = 1050
	elif player.selected_gun == "AR":
		speed = 950
	else:
		pass

func _process(delta):
	position += speed * direction * delta

func _on_timer_timeout():
	queue_free()

func _on_body_entered(body):
	var damage : int
	
	if body.is_in_group("enemies"):
		if body.alive:
			if body.is_in_group("mafia_enforcer"):
				if main.levels[0]:
					if player.selected_gun == "PISTOL":
						damage = randi_range(20, 50)
					elif player.selected_gun == "SMG":
						damage = randi_range(25, 55)
					elif player.selected_gun == "LMG":
						damage = randi_range(30, 60)
					elif player.selected_gun == "AR":
						damage = randi_range(35, 65)
					else:
						pass
				elif main.levels[1]:
					if player.selected_gun == "PISTOL":
						damage = randi_range(15, 45)
					elif player.selected_gun == "SMG":
						damage = randi_range(20, 50)
					elif player.selected_gun == "LMG":
						damage = randi_range(25, 55)
					elif player.selected_gun == "AR":
						damage = randi_range(30, 60)
					else:
						pass
				elif main.levels[2]:
					if player.selected_gun == "PISTOL":
						damage = randi_range(10, 40)
					elif player.selected_gun == "SMG":
						damage = randi_range(15, 45)
					elif player.selected_gun == "LMG":
						damage = randi_range(20, 50)
					elif player.selected_gun == "AR":
						damage = randi_range(25, 55)
					else:
						pass
				elif main.levels[3]:
					if player.selected_gun == "PISTOL":
						damage = randi_range(5, 35)
					elif player.selected_gun == "SMG":
						damage = randi_range(10, 40)
					elif player.selected_gun == "LMG":
						damage = randi_range(15, 45)
					elif player.selected_gun == "AR":
						damage = randi_range(20, 50)
					else:
						pass
				else:
					pass
			elif body.is_in_group("mafia_enforcer_2"):
				if main.levels[0]:
					if player.selected_gun == "PISTOL":
						damage = randi_range(30, 60)
					elif player.selected_gun == "SMG":
						damage = randi_range(35, 65)
					elif player.selected_gun == "LMG":
						damage = randi_range(40, 70)
					elif player.selected_gun == "AR":
						damage = randi_range(45, 75)
					else:
						pass
				elif main.levels[1]:
					if player.selected_gun == "PISTOL":
						damage = randi_range(25, 55)
					elif player.selected_gun == "SMG":
						damage = randi_range(30, 60)
					elif player.selected_gun == "LMG":
						damage = randi_range(35, 65)
					elif player.selected_gun == "AR":
						damage = randi_range(40, 70)
					else:
						pass
				elif main.levels[2]:
					if player.selected_gun == "PISTOL":
						damage = randi_range(20, 50)
					elif player.selected_gun == "SMG":
						damage = randi_range(25, 55)
					elif player.selected_gun == "LMG":
						damage = randi_range(30, 60)
					elif player.selected_gun == "AR":
						damage = randi_range(35, 65)
					else:
						pass
				elif main.levels[3]:
					if player.selected_gun == "PISTOL":
						damage = randi_range(15, 45)
					elif player.selected_gun == "SMG":
						damage = randi_range(20, 50)
					elif player.selected_gun == "LMG":
						damage = randi_range(25, 55)
					elif player.selected_gun == "AR":
						damage = randi_range(30, 60)
					else:
						pass
				else:
					pass
			elif body.is_in_group("mafia_enforcer_3"):
				if main.levels[0]:
					if player.selected_gun == "PISTOL":
						damage = randi_range(10, 40)
					elif player.selected_gun == "SMG":
						damage = randi_range(15, 45)
					elif player.selected_gun == "LMG":
						damage = randi_range(20, 50)
					elif player.selected_gun == "AR":
						damage = randi_range(25, 55)
					else:
						pass
				elif main.levels[1]:
					if player.selected_gun == "PISTOL":
						damage = randi_range(10, 35)
					elif player.selected_gun == "SMG":
						damage = randi_range(15, 40)
					elif player.selected_gun == "LMG":
						damage = randi_range(20, 45)
					elif player.selected_gun == "AR":
						damage = randi_range(25, 50)
					else:
						pass
				elif main.levels[2]:
					if player.selected_gun == "PISTOL":
						damage = randi_range(5, 30)
					elif player.selected_gun == "SMG":
						damage = randi_range(10, 35)
					elif player.selected_gun == "LMG":
						damage = randi_range(15, 40)
					elif player.selected_gun == "AR":
						damage = randi_range(20, 45)
					else:
						pass
				elif main.levels[3]:
					if player.selected_gun == "PISTOL":
						damage = randi_range(5, 25)
					elif player.selected_gun == "SMG":
						damage = randi_range(10, 30)
					elif player.selected_gun == "LMG":
						damage = randi_range(15, 35)
					elif player.selected_gun == "AR":
						damage = randi_range(20, 40)
					else:
						pass
				else:
					pass
			elif body.is_in_group("mafia_enforcer_4"):
				if main.levels[0]:
					if player.selected_gun == "PISTOL":
						damage = randi_range(20, 50)
					elif player.selected_gun == "SMG":
						damage = randi_range(25, 55)
					elif player.selected_gun == "LMG":
						damage = randi_range(30, 60)
					elif player.selected_gun == "AR":
						damage = randi_range(35, 65)
					else:
						pass
				elif main.levels[1]:
					if player.selected_gun == "PISTOL":
						damage = randi_range(15, 45)
					elif player.selected_gun == "SMG":
						damage = randi_range(20, 50)
					elif player.selected_gun == "LMG":
						damage = randi_range(25, 55)
					elif player.selected_gun == "AR":
						damage = randi_range(30, 60)
					else:
						pass
				elif main.levels[2]:
					if player.selected_gun == "PISTOL":
						damage = randi_range(10, 40)
					elif player.selected_gun == "SMG":
						damage = randi_range(15, 45)
					elif player.selected_gun == "LMG":
						damage = randi_range(20, 50)
					elif player.selected_gun == "AR":
						damage = randi_range(25, 55)
					else:
						pass
				elif main.levels[3]:
					if player.selected_gun == "PISTOL":
						damage = randi_range(5, 35)
					elif player.selected_gun == "SMG":
						damage = randi_range(10, 40)
					elif player.selected_gun == "LMG":
						damage = randi_range(15, 45)
					elif player.selected_gun == "AR":
						damage = randi_range(20, 50)
					else:
						pass
				else:
					pass
			elif body.is_in_group("mafia_enforcer_5"):
				if main.levels[3]:
					if player.selected_gun == "PISTOL":
						damage = randi_range(10, 30)
					elif player.selected_gun == "SMG":
						damage = randi_range(15, 35)
					elif player.selected_gun == "LMG":
						damage = randi_range(20, 40)
					elif player.selected_gun == "AR":
						damage = randi_range(25, 45)
					else:
						pass
				else:
					pass
			elif body.is_in_group("mafia_enforcer_6"):
				if main.levels[2]:
					if player.selected_gun == "PISTOL":
						damage = randi_range(10, 40)
					elif player.selected_gun == "SMG":
						damage = randi_range(15, 45)
					elif player.selected_gun == "LMG":
						damage = randi_range(20, 50)
					elif player.selected_gun == "AR":
						damage = randi_range(25, 55)
					else:
						pass
				elif main.levels[3]:
					if player.selected_gun == "PISTOL":
						damage = randi_range(5, 35)
					elif player.selected_gun == "SMG":
						damage = randi_range(10, 40)
					elif player.selected_gun == "LMG":
						damage = randi_range(15, 45)
					elif player.selected_gun == "AR":
						damage = randi_range(20, 50)
					else:
						pass
				else:
					pass
			elif body.is_in_group("mafia_enforcer_7"):
				if main.levels[2]:
					if player.selected_gun == "PISTOL":
						damage = randi_range(10, 35)
					elif player.selected_gun == "SMG":
						damage = randi_range(15, 40)
					elif player.selected_gun == "LMG":
						damage = randi_range(20, 45)
					elif player.selected_gun == "AR":
						damage = randi_range(25, 50)
					else:
						pass
				elif main.levels[3]:
					if player.selected_gun == "PISTOL":
						damage = randi_range(10, 30)
					elif player.selected_gun == "SMG":
						damage = randi_range(15, 35)
					elif player.selected_gun == "LMG":
						damage = randi_range(20, 40)
					elif player.selected_gun == "AR":
						damage = randi_range(25, 45)
					else:
						pass
				else:
					pass
			elif body.is_in_group("mafia_enforcer_8"):
				if main.levels[1]:
					if player.selected_gun == "PISTOL":
						damage = randi_range(15, 45)
					elif player.selected_gun == "SMG":
						damage = randi_range(20, 50)
					elif player.selected_gun == "LMG":
						damage = randi_range(25, 55)
					elif player.selected_gun == "AR":
						damage = randi_range(30, 60)
					else:
						pass
				elif main.levels[2]:
					if player.selected_gun == "PISTOL":
						damage = randi_range(10, 40)
					elif player.selected_gun == "SMG":
						damage = randi_range(15, 45)
					elif player.selected_gun == "LMG":
						damage = randi_range(20, 50)
					elif player.selected_gun == "AR":
						damage = randi_range(25, 55)
					else:
						pass
				elif main.levels[3]:
					if player.selected_gun == "PISTOL":
						damage = randi_range(5, 35)
					elif player.selected_gun == "SMG":
						damage = randi_range(10, 40)
					elif player.selected_gun == "LMG":
						damage = randi_range(15, 45)
					elif player.selected_gun == "AR":
						damage = randi_range(20, 50)
					else:
						pass
				else:
					pass
			elif body.is_in_group("mafia_enforcer_9"):
				if main.levels[1]:
					if player.selected_gun == "PISTOL":
						damage = randi_range(15, 45)
					elif player.selected_gun == "SMG":
						damage = randi_range(20, 50)
					elif player.selected_gun == "LMG":
						damage = randi_range(25, 55)
					elif player.selected_gun == "AR":
						damage = randi_range(30, 60)
					else:
						pass
				elif main.levels[2]:
					if player.selected_gun == "PISTOL":
						damage = randi_range(10, 40)
					elif player.selected_gun == "SMG":
						damage = randi_range(15, 45)
					elif player.selected_gun == "LMG":
						damage = randi_range(20, 50)
					elif player.selected_gun == "AR":
						damage = randi_range(25, 55)
					else:
						pass
				elif main.levels[3]:
					if player.selected_gun == "PISTOL":
						damage = randi_range(5, 35)
					elif player.selected_gun == "SMG":
						damage = randi_range(10, 40)
					elif player.selected_gun == "LMG":
						damage = randi_range(15, 45)
					elif player.selected_gun == "AR":
						damage = randi_range(20, 50)
					else:
						pass
				else:
					pass
			elif body.is_in_group("mafia_enforcer_minion"):
				if main.levels[2]:
					if player.selected_gun == "PISTOL":
						damage = randi_range(10, 40)
					elif player.selected_gun == "SMG":
						damage = randi_range(15, 45)
					elif player.selected_gun == "LMG":
						damage = randi_range(20, 50)
					elif player.selected_gun == "AR":
						damage = randi_range(25, 55)
					else:
						pass
				elif main.levels[3]:
					if player.selected_gun == "PISTOL":
						damage = randi_range(5, 35)
					elif player.selected_gun == "SMG":
						damage = randi_range(10, 40)
					elif player.selected_gun == "LMG":
						damage = randi_range(15, 45)
					elif player.selected_gun == "AR":
						damage = randi_range(20, 50)
					else:
						pass
				else:
					pass
			elif body.is_in_group("boss"):
				if main.levels[4]:
					if player.selected_gun == "PISTOL":
						damage = randi_range(5, 25)
					elif player.selected_gun == "SMG":
						damage = randi_range(5, 25)
					elif player.selected_gun == "LMG":
						damage = randi_range(5, 25)
					elif player.selected_gun == "AR":
						damage = randi_range(5, 25)
					else:
						pass
				else:
					pass
				
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
				main.credits_earned += floor(damage/5)
				
				if body.health <= 0 :
					body.die()
				else:
					pass
				
				queue_free()
	else:
		queue_free()
