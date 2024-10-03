extends CanvasLayer

@onready var main = get_node("/root/Main")
@onready var main_menu = get_node("/root/Main/MainMenu")

func _on_exit_button_pressed():
	main_menu.credits += main.credits_earned
	main_menu.save_data()
	main._ready()
