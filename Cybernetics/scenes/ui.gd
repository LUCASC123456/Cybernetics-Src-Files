extends CanvasLayer

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")

var entered : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	entered = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$PrimaryWeaponSelection.text = "PRIMARY: " + str(player.selected_gun)

func _on_pause_button_mouse_entered():
	entered = true

func _on_pause_button_mouse_exited():
	entered = false

func _on_pause_button_pressed():
	main.pause()


func _on_primary_weapon_selection_mouse_entered():
	entered = true

func _on_primary_weapon_selection_mouse_exited():
	entered = false
