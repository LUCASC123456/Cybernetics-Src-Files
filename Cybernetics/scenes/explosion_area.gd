extends Area2D

@onready var main = get_node('/root/Main')
@onready var player = get_node("/root/Main/Player")
@onready var game_over = get_node("/root/Main/GameOver")

var area : CircleShape2D

const expansion := 300

func _ready():
	area = $CollisionShape2D.shape

func _physics_process(delta):
	if area.radius < 100:
		area.radius += expansion * delta
	else:
		queue_free()

func hit_player_10_missile():
	var damage : int
	
	if player.force_field_activated:
		damage = 0
	else:
		damage = randi_range(20, 25)
	
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
	if main.credits_earned > 0:
		main.credits_earned -= damage
		if main.credits_earned <= 0:
			main.credits_earned = 0
		else:
			pass
	else:
		pass
		
	if player.health <= 0:
		get_tree().paused = true
		game_over.show()
		game_over.display_stats()
	else:
		pass

func _on_body_entered(_body):
	main.hit_player_10_missile()
