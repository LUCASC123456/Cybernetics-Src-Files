extends CanvasLayer

@onready var main = get_node("/root/Main")

var credits_earned : int

# Called when the node enters the scene tree for the first time.
func _ready():
	credits_earned = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_exit_button_pressed():
	main._ready()
