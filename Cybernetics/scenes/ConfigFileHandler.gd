extends Node

var config = ConfigFile.new()

const settings_file_path = "user://settings.ini"

func _ready():
	if not FileAccess.file_exists(settings_file_path):
		config.set_value("keybinding", "move_up", "W")
		config.set_value("keybinding", "move_left", "A")
		config.set_value("keybinding", "move_down", "S")
		config.set_value("keybinding", "move_right", "D")
		config.set_value("keybinding", "shoot", "mouse_1")
		config.set_value("keybinding", "melee", "F")
		config.set_value("keybinding", "primary_weapon", "1")
		config.set_value("keybinding", "secondary_weapon", "2")
		
		config.save(settings_file_path)
	else:
		config.load(settings_file_path)

func save_keybinding(action: String, event: InputEvent):
	var event_str
	if event is InputEventKey:
		event_str = OS.get_keycode_string(event.physical_keycode)
	elif event is InputEventMouseButton:
		event_str = "mouse_" + str(event.button_index)
	
	config.set_value("keybinding", action, event_str)
	config.save(settings_file_path)

func load_keybindings():
	var keybindings = {}
	var keys = config.get_section_keys("keybinding")
	for key in keys:
		var input_event
		var event_str = config.get_value("keybinding", key)
		
		if event_str.contains("mouse_"):
			input_event = InputEventMouseButton.new()
			input_event.button_index = int(event_str.split("_")[1])
		else:
			input_event = InputEventKey.new()
			input_event.keycode = OS.find_keycode_from_string(event_str)
		
		keybindings[key] = input_event
	return keybindings
