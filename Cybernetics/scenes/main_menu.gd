extends CanvasLayer

@onready var main = get_node("/root/Main")
@onready var market = get_node("/root/Main/MarketUI")
@onready var settings = get_node("/root/Main/Settings")

var save_path = "user://save"

var primary_store = {
	"bought" : [true, false, false, false],
	"selected" : 0
}

var secondary_store = {
	"bought" : [true, false],
	"selected" : 0
}

var credits = 0

func _on_play_button_pressed():
	main.new_game()

func _on_shop_button_pressed():
	hide()
	market.show()

func _on_settings_button_pressed():
	hide()
	settings.show()
	
func save_data():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(credits)
	file.store_var(primary_store)
	file.store_var(secondary_store)

func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		credits = file.get_var(credits)
		primary_store = file.get_var()
		secondary_store = file.get_var()
	else:
		credits = 0
