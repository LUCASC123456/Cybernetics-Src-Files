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
		$Hotbar/PowerupTeller/Boost.show()
		$AdrenalineBar.max_value = player.get_node("BoostTimer").wait_time
		$AdrenalineBar.value = player.get_node("BoostTimer").time_left
	elif player.force_field_activated:
		$Hotbar/PowerupTeller/ForceField.show()
		$AdrenalineBar.max_value = player.get_node("ForceFieldTimer").wait_time
		$AdrenalineBar.value = player.get_node("ForceFieldTimer").time_left
	elif player.double_damage_activated:
		$Hotbar/PowerupTeller/DoubleDamage.show()
		$AdrenalineBar.max_value = player.get_node("DoubleDamageTimer").wait_time
		$AdrenalineBar.value = player.get_node("DoubleDamageTimer").time_left
	else:
		$Hotbar/PowerupTeller/Boost.hide()
		$Hotbar/PowerupTeller/ForceField.hide()
		$Hotbar/PowerupTeller/DoubleDamage.hide()
		$AdrenalineBar.max_value = 1
		$AdrenalineBar.value = 0
	
	$Hotbar/PrimaryWeaponSelection/SelectedWeapon.text = "(1) PRIMARY: " + str(player.primary_selected_gun)
	$Hotbar/SecondaryWeaponSelection/SelectedWeapon.text = "(2) SECONADRY: " + str(player.secondary_selected_gun)
	
	if player.primary_selected_gun == "PISTOL":
		for image in $Hotbar/PrimaryWeaponSelection.get_children():
			if image is Label:
				pass
			elif image.name == "Pistol":
				image.show()
			else:
				image.hide()
	elif player.primary_selected_gun == "SMG":
		for image in $Hotbar/PrimaryWeaponSelection.get_children():
			if image is Label:
				pass
			elif image.name == "SMG":
				image.show()
			else:
				image.hide()
	elif player.primary_selected_gun == "LMG":
		for image in $Hotbar/PrimaryWeaponSelection.get_children():
			if image is Label:
				pass
			elif image.name == "LMG":
				image.show()
			else:
				image.hide()
	elif player.primary_selected_gun == "AR":
		for image in $Hotbar/PrimaryWeaponSelection.get_children():
			if image is Label:
				pass
			elif image.name == "AR":
				image.show()
			else:
				image.hide()
	else:
		pass
	
	if player.secondary_selected_gun == "PISTOL":
		for image in $Hotbar/SecondaryWeaponSelection.get_children():
			if image is Label:
				pass
			elif image.name == "Pistol":
				image.show()
			else:
				image.hide()
	elif player.secondary_selected_gun == "MP":
		for image in $Hotbar/SecondaryWeaponSelection.get_children():
			if image is Label:
				pass
			elif image.name == "MP":
				image.show()
			else:
				image.hide()
	
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
	else:
		pass

func _on_pause_button_mouse_entered():
	ui_mouse_entered = true

func _on_pause_button_mouse_exited():
	ui_mouse_entered = false

func _on_primary_weapon_selection_mouse_entered():
	ui_mouse_entered = true

func _on_primary_weapon_selection_mouse_exited():
	ui_mouse_entered = false

func _on_secondary_weapon_selection_2_mouse_entered():
	ui_mouse_entered = true

func _on_secondary_weapon_selection_2_mouse_exited():
	ui_mouse_entered = false


func _on_pause_button_pressed():
	main.pause()


func _on_primary_weapon_selection_pressed():
	if not player.primary_equipped:
		player.primary_equipped = true
		
		$Hotbar/PrimaryWeaponSelection.texture_normal = ResourceLoader.load("res://assets/GamePlayUI/WeaponSelectionSelected.png")
		$Hotbar/SecondaryWeaponSelection.texture_normal = ResourceLoader.load("res://assets/GamePlayUI/WeaponSelection.png")
		
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
		
		$Hotbar/SecondaryWeaponSelection.texture_normal = ResourceLoader.load("res://assets/GamePlayUI/WeaponSelectionSelected.png")
		$Hotbar/PrimaryWeaponSelection.texture_normal = ResourceLoader.load("res://assets/GamePlayUI/WeaponSelection.png")
		
		if not player.get_node("ReloadTimerPrimary").is_stopped():
			player.get_node("ReloadTimerPrimary").stop()
		else:
			pass
			
		player.can_shoot = true
	else:
		pass
