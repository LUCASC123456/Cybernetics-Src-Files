extends CanvasLayer

@onready var market = get_node("/root/Main/MarketUI")

func _on_ok_button_pressed():
	hide()
	market.show()
