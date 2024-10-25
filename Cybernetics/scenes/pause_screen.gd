extends CanvasLayer

@onready var main = get_node("/root/Main")

#resumes the game so the user can resume whenver they wish
func _on_resume_button_pressed():
	main.resume()

#exits the game so the user can exit the game whenver they wish
func _on_exit_button_pressed():
	main._ready()
