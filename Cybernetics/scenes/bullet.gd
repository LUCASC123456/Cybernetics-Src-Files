extends Area2D

@onready var main = get_node("/root/Main")
@onready var game_won = get_node("/root/Main/GameWon")
@onready var player = get_node("/root/Main/Player")

var speed : int = 0
var direction : Vector2
var damage : int

func _ready():
	if player.selected_gun == "PISTOL":
		speed = 750
	elif player.selected_gun == "SMG":
		speed = 850
	elif player.selected_gun == "LMG":
		speed = 1050
	elif player.selected_gun == "AR":
		speed = 950

func _process(delta):
	position += speed * direction * delta

func _on_timer_timeout():
	queue_free()

func _on_body_entered(body):
	if body.name == "World":
		queue_free()
	else:
		if body.alive:
			if body.is_in_group("mafia_enforcer"):
				if main.levels[0] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(20, 50)
					elif player.selected_gun == "SMG":
						damage = randi_range(25, 55)
					elif player.selected_gun == "LMG":
						damage = randi_range(30, 60)
					elif player.selected_gun == "AR":
						damage = randi_range(35, 65)
				elif main.levels[1] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(15, 45)
					elif player.selected_gun == "SMG":
						damage = randi_range(20, 50)
					elif player.selected_gun == "LMG":
						damage = randi_range(25, 55)
					elif player.selected_gun == "AR":
						damage = randi_range(30, 60)
				elif main.levels[2] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(10, 40)
					elif player.selected_gun == "SMG":
						damage = randi_range(15, 45)
					elif player.selected_gun == "LMG":
						damage = randi_range(20, 50)
					elif player.selected_gun == "AR":
						damage = randi_range(25, 55)
				elif main.levels[3] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(5, 35)
					elif player.selected_gun == "SMG":
						damage = randi_range(10, 40)
					elif player.selected_gun == "LMG":
						damage = randi_range(15, 45)
					elif player.selected_gun == "AR":
						damage = randi_range(20, 50)
	
			elif body.is_in_group("mafia_enforcer_2"):
				if main.levels[0] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(30, 60)
					elif player.selected_gun == "SMG":
						damage = randi_range(35, 65)
					elif player.selected_gun == "LMG":
						damage = randi_range(40, 70)
					elif player.selected_gun == "AR":
						damage = randi_range(45, 75)
				elif main.levels[1] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(25, 55)
					elif player.selected_gun == "SMG":
						damage = randi_range(30, 60)
					elif player.selected_gun == "LMG":
						damage = randi_range(35, 65)
					elif player.selected_gun == "AR":
						damage = randi_range(40, 70)
				elif main.levels[2] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(20, 50)
					elif player.selected_gun == "SMG":
						damage = randi_range(25, 55)
					elif player.selected_gun == "LMG":
						damage = randi_range(30, 60)
					elif player.selected_gun == "AR":
						damage = randi_range(35, 65)
				elif main.levels[3] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(15, 45)
					elif player.selected_gun == "SMG":
						damage = randi_range(20, 50)
					elif player.selected_gun == "LMG":
						damage = randi_range(25, 55)
					elif player.selected_gun == "AR":
						damage = randi_range(30, 60)
				
			elif body.is_in_group("mafia_enforcer_3"):
				if main.levels[0] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(10, 40)
					elif player.selected_gun == "SMG":
						damage = randi_range(15, 45)
					elif player.selected_gun == "LMG":
						damage = randi_range(20, 50)
					elif player.selected_gun == "AR":
						damage = randi_range(25, 55)
				elif main.levels[1] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(10, 35)
					elif player.selected_gun == "SMG":
						damage = randi_range(15, 40)
					elif player.selected_gun == "LMG":
						damage = randi_range(20, 45)
					elif player.selected_gun == "AR":
						damage = randi_range(25, 50)
				elif main.levels[2] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(5, 30)
					elif player.selected_gun == "SMG":
						damage = randi_range(10, 35)
					elif player.selected_gun == "LMG":
						damage = randi_range(15, 40)
					elif player.selected_gun == "AR":
						damage = randi_range(20, 45)
				elif main.levels[3] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(5, 25)
					elif player.selected_gun == "SMG":
						damage = randi_range(10, 30)
					elif player.selected_gun == "LMG":
						damage = randi_range(15, 35)
					elif player.selected_gun == "AR":
						damage = randi_range(20, 40)
			
			elif body.is_in_group("mafia_enforcer_4"):
				if main.levels[0] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(20, 50)
					elif player.selected_gun == "SMG":
						damage = randi_range(25, 55)
					elif player.selected_gun == "LMG":
						damage = randi_range(30, 60)
					elif player.selected_gun == "AR":
						damage = randi_range(35, 65)
				elif main.levels[1] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(15, 45)
					elif player.selected_gun == "SMG":
						damage = randi_range(20, 50)
					elif player.selected_gun == "LMG":
						damage = randi_range(25, 55)
					elif player.selected_gun == "AR":
						damage = randi_range(30, 60)
				elif main.levels[2] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(10, 40)
					elif player.selected_gun == "SMG":
						damage = randi_range(15, 45)
					elif player.selected_gun == "LMG":
						damage = randi_range(20, 50)
					elif player.selected_gun == "AR":
						damage = randi_range(25, 55)
				elif main.levels[3] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(5, 35)
					elif player.selected_gun == "SMG":
						damage = randi_range(10, 40)
					elif player.selected_gun == "LMG":
						damage = randi_range(15, 45)
					elif player.selected_gun == "AR":
						damage = randi_range(20, 50)
						
			elif body.is_in_group("mafia_enforcer_5"):
				if main.levels[0] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(15, 45)
					elif player.selected_gun == "SMG":
						damage = randi_range(20, 50)
					elif player.selected_gun == "LMG":
						damage = randi_range(25, 55)
					elif player.selected_gun == "AR":
						damage = randi_range(30, 60)
				elif main.levels[1] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(15, 40)
					elif player.selected_gun == "SMG":
						damage = randi_range(20, 45)
					elif player.selected_gun == "LMG":
						damage = randi_range(25, 50)
					elif player.selected_gun == "AR":
						damage = randi_range(30, 55)
				elif main.levels[2] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(10, 35)
					elif player.selected_gun == "SMG":
						damage = randi_range(15, 40)
					elif player.selected_gun == "LMG":
						damage = randi_range(20, 45)
					elif player.selected_gun == "AR":
						damage = randi_range(25, 50)
				elif main.levels[3] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(10, 30)
					elif player.selected_gun == "SMG":
						damage = randi_range(15, 35)
					elif player.selected_gun == "LMG":
						damage = randi_range(20, 40)
					elif player.selected_gun == "AR":
						damage = randi_range(25, 45)
						
			elif body.is_in_group("mafia_enforcer_6"):
				if main.levels[0] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(20, 50)
					elif player.selected_gun == "SMG":
						damage = randi_range(25, 55)
					elif player.selected_gun == "LMG":
						damage = randi_range(30, 60)
					elif player.selected_gun == "AR":
						damage = randi_range(35, 65)
				elif main.levels[1] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(15, 45)
					elif player.selected_gun == "SMG":
						damage = randi_range(20, 50)
					elif player.selected_gun == "LMG":
						damage = randi_range(25, 55)
					elif player.selected_gun == "AR":
						damage = randi_range(30, 60)
				elif main.levels[2] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(10, 40)
					elif player.selected_gun == "SMG":
						damage = randi_range(15, 45)
					elif player.selected_gun == "LMG":
						damage = randi_range(20, 50)
					elif player.selected_gun == "AR":
						damage = randi_range(25, 55)
				elif main.levels[3] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(5, 35)
					elif player.selected_gun == "SMG":
						damage = randi_range(10, 40)
					elif player.selected_gun == "LMG":
						damage = randi_range(15, 45)
					elif player.selected_gun == "AR":
						damage = randi_range(20, 50)
						
			elif body.is_in_group("mafia_enforcer_7"):
				if main.levels[0] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(15, 45)
					elif player.selected_gun == "SMG":
						damage = randi_range(20, 50)
					elif player.selected_gun == "LMG":
						damage = randi_range(25, 55)
					elif player.selected_gun == "AR":
						damage = randi_range(30, 60)
				elif main.levels[1] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(15, 40)
					elif player.selected_gun == "SMG":
						damage = randi_range(20, 45)
					elif player.selected_gun == "LMG":
						damage = randi_range(25, 50)
					elif player.selected_gun == "AR":
						damage = randi_range(30, 55)
				elif main.levels[2] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(10, 35)
					elif player.selected_gun == "SMG":
						damage = randi_range(15, 40)
					elif player.selected_gun == "LMG":
						damage = randi_range(20, 45)
					elif player.selected_gun == "AR":
						damage = randi_range(25, 50)
				elif main.levels[3] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(10, 30)
					elif player.selected_gun == "SMG":
						damage = randi_range(15, 35)
					elif player.selected_gun == "LMG":
						damage = randi_range(20, 40)
					elif player.selected_gun == "AR":
						damage = randi_range(25, 45)

			elif body.is_in_group("mafia_enforcer_8"):
				if main.levels[0] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(20, 50)
					elif player.selected_gun == "SMG":
						damage = randi_range(25, 55)
					elif player.selected_gun == "LMG":
						damage = randi_range(30, 60)
					elif player.selected_gun == "AR":
						damage = randi_range(35, 65)
				elif main.levels[1] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(15, 45)
					elif player.selected_gun == "SMG":
						damage = randi_range(20, 50)
					elif player.selected_gun == "LMG":
						damage = randi_range(25, 55)
					elif player.selected_gun == "AR":
						damage = randi_range(30, 60)
				elif main.levels[2] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(10, 40)
					elif player.selected_gun == "SMG":
						damage = randi_range(15, 45)
					elif player.selected_gun == "LMG":
						damage = randi_range(20, 50)
					elif player.selected_gun == "AR":
						damage = randi_range(25, 55)
				elif main.levels[3] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(5, 35)
					elif player.selected_gun == "SMG":
						damage = randi_range(10, 40)
					elif player.selected_gun == "LMG":
						damage = randi_range(15, 45)
					elif player.selected_gun == "AR":
						damage = randi_range(20, 50)
						
			elif body.is_in_group("mafia_enforcer_9"):
				if main.levels[0] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(20, 50)
					elif player.selected_gun == "SMG":
						damage = randi_range(25, 55)
					elif player.selected_gun == "LMG":
						damage = randi_range(30, 60)
					elif player.selected_gun == "AR":
						damage = randi_range(35, 65)
				elif main.levels[1] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(15, 45)
					elif player.selected_gun == "SMG":
						damage = randi_range(20, 50)
					elif player.selected_gun == "LMG":
						damage = randi_range(25, 55)
					elif player.selected_gun == "AR":
						damage = randi_range(30, 60)
				elif main.levels[2] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(10, 40)
					elif player.selected_gun == "SMG":
						damage = randi_range(15, 45)
					elif player.selected_gun == "LMG":
						damage = randi_range(20, 50)
					elif player.selected_gun == "AR":
						damage = randi_range(25, 55)
				elif main.levels[3] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(5, 35)
					elif player.selected_gun == "SMG":
						damage = randi_range(10, 40)
					elif player.selected_gun == "LMG":
						damage = randi_range(15, 45)
					elif player.selected_gun == "AR":
						damage = randi_range(20, 50)
						
			elif body.is_in_group("mafia_enforcer_minion"):
				if main.levels[0] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(20, 50)
					elif player.selected_gun == "SMG":
						damage = randi_range(25, 55)
					elif player.selected_gun == "LMG":
						damage = randi_range(30, 60)
					elif player.selected_gun == "AR":
						damage = randi_range(35, 65)
				elif main.levels[1] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(15, 45)
					elif player.selected_gun == "SMG":
						damage = randi_range(20, 50)
					elif player.selected_gun == "LMG":
						damage = randi_range(25, 55)
					elif player.selected_gun == "AR":
						damage = randi_range(30, 60)
				elif main.levels[2] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(10, 40)
					elif player.selected_gun == "SMG":
						damage = randi_range(15, 45)
					elif player.selected_gun == "LMG":
						damage = randi_range(20, 50)
					elif player.selected_gun == "AR":
						damage = randi_range(25, 55)
				elif main.levels[3] == true:
					if player.selected_gun == "PISTOL":
						damage = randi_range(5, 35)
					elif player.selected_gun == "SMG":
						damage = randi_range(10, 40)
					elif player.selected_gun == "LMG":
						damage = randi_range(15, 45)
					elif player.selected_gun == "AR":
						damage = randi_range(20, 50)
			
			if body.damage_resistant == false:
				body.health -= damage
				main.credits_earned += floor(damage/5)
				body.get_node("EnemyHealthBar").value = body.health
				if body.health <= 0 and body.get_node("EnemyHealthBar").value <= 0:
					body.die()
				queue_free()
			else:
				if body.entered:
					pass
				else:
					queue_free()
