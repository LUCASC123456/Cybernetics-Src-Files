extends Area2D

@onready var game_won = get_node("/root/Main/GameWon")
@onready var player = get_node("/root/Main/Player")

var speed : int = 0
var direction : Vector2
var random : int

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
			if player.selected_gun == "PISTOL":
				random = randi_range(20, 50)
			elif player.selected_gun == "SMG":
				random = randi_range(30, 60)
			elif player.selected_gun == "LMG":
				random = randi_range(40, 70)
			elif player.selected_gun == "AR":
				random = randi_range(50, 80)
			body.health -= random
			game_won.credits_earned += floor(random/5)
			body.get_child(4).value = body.health
			if body.health <= 0 and body.get_child(4).value <= 0:
				body.die()
			queue_free()
