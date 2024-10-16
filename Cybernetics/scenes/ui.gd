extends CanvasLayer

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")

var ui_mouse_entered : bool

func _ready():
	ui_mouse_entered = false

func _process(_delta):
	$HealthBar.value = player.health
	$PrimaryWeaponSelection.text = "PRIMARY: " + str(player.selected_gun)
	$EnemyCounter/EnemiesLabel.text = "ENEMIES LEFT: " + str(main.enemies_left)
	
	if main.levels[0]:
		$RoomCounter/RoomLabel.text = "ROOM: 1/5"
	elif main.levels[1]:
		$RoomCounter/RoomLabel.text = "ROOM: 2/5"
	elif main.levels[2]:
		$RoomCounter/RoomLabel.text = "ROOM: 3/5"
	elif main.levels[3]:
		$RoomCounter/RoomLabel.text = "ROOM: 4/5"
	elif main.levels[4]:
		$RoomCounter/RoomLabel.text = "ROOM: 5/5"

func _on_pause_button_mouse_entered():
	ui_mouse_entered = true

func _on_pause_button_mouse_exited():
	ui_mouse_entered = false

func _on_primary_weapon_selection_mouse_entered():
	ui_mouse_entered = true

func _on_primary_weapon_selection_mouse_exited():
	ui_mouse_entered = false

func _on_pause_button_pressed():
	main.pause()
