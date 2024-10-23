extends Area2D

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")

var swinging : bool
var swing_clockwise : bool

const swing_increment := ((3*PI)/4)/0.25

func _ready():
	visible = false

func _process(delta):
	if swinging:
		if swing_clockwise:
			rotation += swing_increment * delta
		else:
			rotation -= swing_increment * delta
		
		monitoring = true
		visible = true
	else:
		monitoring = false
		visible = false

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
	else:
		queue_free()
