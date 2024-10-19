extends CanvasLayer

@onready var main_menu = get_node("/root/Main/MainMenu")

func _on_exit_button_pressed():
	hide()
	main_menu.show()
