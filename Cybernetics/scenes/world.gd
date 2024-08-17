extends TileMap

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _on_level_1_body_entered(_body):
	main.levels[0] = true
	
func _on_level_1_body_exited(_body):
	main.levels[0] = false
	$Level1/CollisionShape2D.set_deferred("disabled", true)

func _on_level_2_body_entered(_body):
	main.levels[1] = true
	main.new_game()

func _on_level_2_body_exited(body):
	if body.position.x >= 2713:
		main.levels[1] = false
		$Level2/CollisionShape2D.set_deferred("disabled", true)
	else:
		pass
	
func _on_level_3_body_entered(_body):
	main.levels[2] = true
	main.new_game()

func _on_level_3_body_exited(body):
	if body.position.y >= 2377:
		main.levels[2] = false
		$Level3/CollisionShape2D.set_deferred("disabled", true)
	else:
		pass

func _on_level_4_body_entered(_body):
	main.levels[3] = true
	main.new_game()

func _on_level_4_body_exited(body):
	if body.position.x >= 8041 and body.position.x <= 8183 and body.position.y >= 2377:
		main.levels[3] = false
		$Level4/CollisionShape2D.set_deferred("disabled", true)
	else:
		pass

func _on_level_5_body_entered(_body):
	main.levels[4] = true
	main.new_game()

func _on_level_5_body_exited(_body):
	#main.levels[4] = false
	#$Level5/CollisionShape2D.set_deferred("disabled", true)
	pass
