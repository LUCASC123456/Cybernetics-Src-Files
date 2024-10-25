extends CanvasLayer

@onready var main = get_node("/root/Main")
@onready var market = get_node("/root/Main/MarketUI")
@onready var settings = get_node("/root/Main/Settings")

var save_path = "user://save"

#storing user data reguarding which primary weapons the user has indicated by whether they're represented
#by true or false in the bought array and which primary weapon is equipped indicated by selected representing
#the index in the bought array of the selected weapon
var primary_store = {
	"bought" : [true, false, false, false],
	"selected" : 0
}

#storing user data reguarding which secondary weapons the user has indicated by whether they're represented
#by true or false in the bought array and which secondary weapon is equipped indicated by selected representing
#the index in the bought array of the selected weapon
var secondary_store = {
	"bought" : [true, false],
	"selected" : 0
}

var credits = 0

#when the user presses the play button, start a new game using the new_game function in main so the
#player can actually play the game
func _on_play_button_pressed():
	main.new_game()

#when the user presses the shop button, hide the main menu ui and show the shop ui instead so the
#player can go an purchase weapons
func _on_shop_button_pressed():
	hide()
	market.show()

#when the user presses the exit button the godot run stops so the user can leave when they wish to
func _on_exit_button_pressed():
	get_tree().quit()

#when the user presses the settings button, hide the main menu ui and show the settings ui instead
#so the player can look at and edit settings
func _on_settings_button_pressed():
	hide()
	settings.show()

#saves the user data by writing data into save_path user data file and storing information such as
#credits, primary weapon data and secondary weapon data so the user doesn't lose data
func save_data():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(credits)
	file.store_var(primary_store)
	file.store_var(secondary_store)

#loads the user data by firstly checking if the save_path user data folder exists and if it does,
#read the data from file and assign the values to user data that needs to save i.e. credits, primary
#weapon data and secondary weapon data, otherwise reset the redits so the end user can use their saved
#data
func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		credits = file.get_var(credits)
		primary_store = file.get_var()
		secondary_store = file.get_var()
	else:
		credits = 0.
