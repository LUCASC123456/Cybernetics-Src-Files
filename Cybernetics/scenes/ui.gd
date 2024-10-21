extends CanvasLayer

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")

var ui_mouse_entered : bool

func _ready():
	ui_mouse_entered = false

func _process(_delta):
	$HealthBar.value = player.health
	$SheildBar.value = player.sheild
	
	if player.boost_activated:
		$PowerupTeller/PowerupLabel.text = "POWERUP:\nBOOST"
		$AdrenalineBar.max_value = player.get_node("BoostTimer").wait_time
		$AdrenalineBar.value = player.get_node("BoostTimer").time_left
	elif player.force_field_activated:
		$PowerupTeller/PowerupLabel.text = "POWERUP:\nFORCE FIELD"
		$AdrenalineBar.max_value = player.get_node("ForceFieldTimer").wait_time
		$AdrenalineBar.value = player.get_node("ForceFieldTimer").time_left
	elif player.double_damage_activated:
		$PowerupTeller/PowerupLabel.text = "POWERUP:\nDOUBLE DAMAGE"
		$AdrenalineBar.max_value = player.get_node("DoubleDamageTimer").wait_time
		$AdrenalineBar.value = player.get_node("DoubleDamageTimer").time_left
	else:
		$PowerupTeller/PowerupLabel.text = "POWERUP:\nNONE"
		$AdrenalineBar.max_value = 1
		$AdrenalineBar.value = 0
	
	$PrimaryWeaponSelection.text = "PRIMARY: " + str(player.primary_selected_gun)
	$SecondaryWeaponSelection.text = "SECONADRY: " + str(player.secondary_selected_gun)
	
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


func _on_primary_weapon_selection_pressed():
	if not player.primary_equipped:
		player.primary_equipped = true
		
		if not player.get_node("ReloadTimerSecondary").is_stopped():
			player.get_node("ReloadTimerSecondary").stop()
		else:
			pass
		
		player.can_shoot = true
	else:
		pass

func _on_secondary_weapon_selection_pressed():
	if player.primary_equipped:
		player.primary_equipped = false
			
		if not player.get_node("ReloadTimerPrimary").is_stopped():
			player.get_node("ReloadTimerPrimary").stop()
		else:
			pass
			
		player.can_shoot = true
	else:
		pass
