extends CanvasLayer

@onready var main = get_node("/root/Main")

func _on_resume_button_pressed():
	main.resume()

func _on_exit_button_pressed():
	main._ready()
