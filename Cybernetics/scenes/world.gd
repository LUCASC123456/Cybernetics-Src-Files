extends TileMap

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _on_level_1_body_entered(_body):
	main.levels[0] = true
	
func _on_level_1_body_exited(_body):
	main.levels[0] = false

func _on_level_2_body_entered(_body):
	main.levels[1] = true

func _on_level_2_body_exited(_body):
	main.levels[1] = false
	
func _on_level_3_body_entered(_body):
	main.levels[2] = true

func _on_level_3_body_exited(_body):
	main.levels[2] = false

func _on_level_4_body_entered(_body):
	main.levels[3] = true

func _on_level_4_body_exited(_body):
	main.levels[3] = false

func _on_level_5_body_entered(_body):
	main.levels[4] = true

func _on_level_5_body_exited(_body):
	main.levels[0] = false
