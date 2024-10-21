extends Area2D

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")
@onready var game_over = get_node("/root/Main/GameOver")

@export var speed: int = 950

const direction = Vector2.RIGHT

var area_collider_count : int
var bullet_collisions : bool

func ready():
	bullet_collisions = false

func _physics_process(delta):
	var velocity = direction.rotated(rotation) * speed * delta
	global_position += velocity

func hit_player_9():
	var damage : int
	
	if player.force_field_activated:
		damage = 0
	else:
		if main.levels[1]:
			damage = randi_range(10, 15)
		elif main.levels[2]:
			damage = randi_range(15, 20)
		elif main.levels[3]:
			damage = randi_range(20, 25)
		else:
			pass
	
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
		hit_player_9()
		queue_free()
	elif body.is_in_group("enemies"):
		if bullet_collisions:
			queue_free()
		else:
			area_collider_count += 1
	else:
		queue_free()

func _on_body_exited(body):
	if body.is_in_group("enemies"):
		area_collider_count -= 1
		
		if area_collider_count == 0:
			bullet_collisions = true
		else:
			pass

func _on_timer_timeout():
	queue_free()
