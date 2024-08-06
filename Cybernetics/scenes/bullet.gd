extends Area2D

@onready var game_won = get_node("/root/Main/GameWon")

var speed : int = 500
var direction : Vector2
var random : int

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += speed * direction * delta


func _on_timer_timeout():
	queue_free()


func _on_body_entered(body):
	if body.name == "World":
		queue_free()
	else:
		if body.alive:
			random = randi_range(20, 50)
			body.health -= random
			game_won.credits_earned += floor(random/5)
			body.get_child(4).value = body.health
			if body.health <= 0 and body.get_child(4).value <= 0:
				body.die()
			queue_free()
