extends CanvasLayer

@onready var market = get_node("/root/Main/MarketUI")

#hide the not enought credits screen and show the market screen so the end user can go back to the
#market ui screen after being notified
func _on_ok_button_pressed():
	hide()
	market.show()
