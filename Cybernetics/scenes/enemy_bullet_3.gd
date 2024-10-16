extends Area2D

@onready var main = get_node("/root/Main")

@export var speed: int = 950

const direction = Vector2.RIGHT

func _physics_process(delta):
	var velocity = direction.rotated(rotation) * speed * delta
	global_position += velocity

func _on_body_entered(body):
	if body.name == "Player":
		main.hit_player_10_bullet()
		queue_free()
	else:
		queue_free()

func _on_timer_timeout():
	queue_free()
