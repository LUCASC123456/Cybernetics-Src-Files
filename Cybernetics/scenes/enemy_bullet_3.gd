extends Area2D

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")
@onready var game_over = get_node("/root/Main/GameOver")

@export var speed: int = 950

const direction = Vector2.RIGHT

func _physics_process(delta):
	var velocity = direction.rotated(rotation) * speed * delta
	global_position += velocity

func hit_player_10_bullet():
	var damage : int
	
	if player.force_field_activated:
		damage = 0
	else:
		damage = randi_range(10, 15)
	
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

func _on_body_entered(body):
	if body.name == "Player":
		hit_player_10_bullet()
		queue_free()
	else:
		queue_free()

func _on_timer_timeout():
	queue_free()
