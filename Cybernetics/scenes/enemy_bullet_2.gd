extends Area2D

@onready var main = get_node("/root/Main")

@export var speed: int = 950

const direction = Vector2.RIGHT

var area_collider_count : int
var bullet_collisions : bool

func ready():
	bullet_collisions = false

func _physics_process(delta):
	var velocity = direction.rotated(rotation) * speed * delta
	global_position += velocity

func _on_body_entered(body):
	if body.name == "Player":
		main.hit_player_9()
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
