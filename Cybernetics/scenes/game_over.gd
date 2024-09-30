extends CanvasLayer

@onready var main = get_node("/root/Main")

func _on_exit_button_pressed():
	main._ready()
