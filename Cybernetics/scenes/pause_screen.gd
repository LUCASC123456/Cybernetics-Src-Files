extends CanvasLayer

@onready var main = get_node("/root/Main")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_resume_button_pressed():
	main.resume()


func _on_exit_button_pressed():
	main._ready()
