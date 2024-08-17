extends CanvasLayer

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")
@onready var main_menu = get_node("/root/Main/MainMenu")

var credits_earned : int

# Called when the node enters the scene tree for the first time.
func _ready():
	credits_earned = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_exit_button_pressed():
	main_menu.credits += credits_earned
	main_menu.save_data()
	player.get_child(0).get_child(0).process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	player.get_child(0).get_child(0).limit_left = 0
	player.get_child(0).get_child(0).limit_top = 0
	player.get_child(0).get_child(0).limit_right = 9216
	player.get_child(0).get_child(0).limit_bottom = 6768
	player.get_child(0).get_child(0).position_smoothing_enabled = false
	player.get_child(0).get_child(0).drag_horizontal_enabled = false
	player.get_child(0).get_child(0).drag_vertical_enabled = false
	main._ready()
