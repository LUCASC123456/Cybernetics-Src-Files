extends CanvasLayer

@onready var main = get_node("/root/Main")
@onready var market = get_node("/root/Main/MarketUI")

var save_path = "user://save"

var store = {
	"bought" : [true, false, false, false],
	"selected" : 0,
}

var credits = 0

func _on_play_button_pressed():
	main.new_game()

func save_data():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(credits)
	file.store_var(store)

func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		credits = file.get_var(credits)
		store = file.get_var()
	else:
		credits = 0
		
func _on_shop_button_pressed():
	hide()
	market.show()
