extends Area2D

@onready var main = get_node('/root/Main')

var area : CircleShape2D

const expansion := 300

func _ready():
	area = $CollisionShape2D.shape

func _physics_process(delta):
	if area.radius < 100:
		area.radius += expansion * delta
	else:
		queue_free()

func _on_body_entered(_body):
	main.hit_player_10_missile()
