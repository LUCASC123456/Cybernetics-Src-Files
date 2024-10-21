extends CanvasLayer

@onready var main_menu = get_node("/root/Main/MainMenu")
@onready var not_enough_credits = get_node("/root/Main/NotEnoughCredits")

@onready var PWButton1 = $PrimaryWeapons/PanelContainer/MarginContainer/ScrollContainer/ActionList/Row1/MarginContainer/HBoxContainer/PWButton1
@onready var PWButton2 = $PrimaryWeapons/PanelContainer/MarginContainer/ScrollContainer/ActionList/Row1/MarginContainer/HBoxContainer/PWButton2
@onready var PWButton3 = $PrimaryWeapons/PanelContainer/MarginContainer/ScrollContainer/ActionList/Row2/MarginContainer/HBoxContainer/PWButton3
@onready var PWButton4 = $PrimaryWeapons/PanelContainer/MarginContainer/ScrollContainer/ActionList/Row2/MarginContainer/HBoxContainer/PWButton4

@onready var SWButton1 = $SecondaryWeapons/PanelContainer/MarginContainer/ScrollContainer/ActionList/Row1/MarginContainer/HBoxContainer/SWButton1
@onready var SWButton2 = $SecondaryWeapons/PanelContainer/MarginContainer/ScrollContainer/ActionList/Row1/MarginContainer/HBoxContainer/SWButton2

@onready var PWButtons = [PWButton1, PWButton2, PWButton3, PWButton4]
@onready var SWButtons = [SWButton1, SWButton2]

var pistol_price = 0
var mp_price = 500
var smg_price = 500
var lmg_price = 1500
var ar_price = 1000

func _ready():
	main_menu.load_data()
	
	for item in range(0, len(PWButtons)):
		if main_menu.primary_store.bought[item]:
			PWButtons[item].text = "SELECT"
		else:
			pass
		
	PWButtons[main_menu.primary_store.selected].text = "SELECTED"
	PWButtons[main_menu.primary_store.selected].add_to_group("primary_selected")
	
	for item in range(0, len(SWButtons)):
		if main_menu.secondary_store.bought[item]:
			SWButtons[item].text = "SELECT"
		else:
			pass
	
	SWButtons[main_menu.secondary_store.selected].text = "SELECTED"
	PWButtons[main_menu.secondary_store.selected].add_to_group("secondary_selected")
	
func _process(_delta):
	$CreditsAvailable.text = "CREDITS AVAILABLE: " + str(main_menu.credits)

func _select_primary(node, no):
	main_menu.load_data()
	
	for button in get_tree().get_nodes_in_group("primary_selected"):
		button.text = "SELECT"
		button.remove_from_group("primary_selected")
	
	node.text = "SELECTED"
	node.add_to_group("primary_selected")
	main_menu.primary_store.selected = no
	main_menu.save_data()

func _select_secondary(node, no):
	main_menu.load_data()
	
	for button in get_tree().get_nodes_in_group("secondary_selected"):
		button.text = "SELECT"
		button.remove_from_group("secondary_selected")
	
	node.text = "SELECTED"
	node.add_to_group("secondary_selected")
	main_menu.secondary_store.selected = no
	main_menu.save_data()


func _buy_primary(price, item_no):
	main_menu.load_data()
	
	if not main_menu.primary_store.bought[item_no]:
		if main_menu.credits >= price:
			main_menu.credits -= price
			main_menu.primary_store.bought[item_no] = true
			PWButtons[item_no].text = "SELECT"
			main_menu.save_data()
		else:
			var rem = price - main_menu.credits
			not_enough_credits.get_node("NotEnoughCreditsLabel").text = "YOU NEED " + str(rem) + " MORE CREDITS\n TO PURCHASE THIS ITEM"
			not_enough_credits.show()
	else:
		_select_primary(PWButtons[item_no], item_no)

func _buy_secondary(price, item_no):
	main_menu.load_data()
	
	if not main_menu.secondary_store.bought[item_no]:
		if main_menu.credits >= price:
			main_menu.credits -= price
			main_menu.secondary_store.bought[item_no] = true
			SWButtons[item_no].text = "SELECT"
			main_menu.save_data()
		else:
			var rem = price - main_menu.credits
			not_enough_credits.get_node("NotEnoughCreditsLabel").text = "YOU NEED " + str(rem) + " MORE CREDITS\n TO PURCHASE THIS ITEM"
			not_enough_credits.show()
	else:
		_select_secondary(SWButtons[item_no], item_no)


func _on_exit_button_pressed():
	hide()
	main_menu.show()


func _on_pw_button_1_pressed():
	_buy_primary(pistol_price, 0)

func _on_pw_button_2_pressed():
	_buy_primary(smg_price, 1)

func _on_pw_button_3_pressed():
	_buy_primary(lmg_price, 2)

func _on_pw_button_4_pressed():
	_buy_primary(ar_price, 3)


func _on_sw_button_1_pressed():
	_buy_secondary(pistol_price, 0)

func _on_sw_button_2_pressed():
	_buy_secondary(mp_price, 0)


func _on_primary_weapons_button_pressed():
	if not $PrimaryWeapons.visible:
		$SecondaryWeapons.hide()
		$PrimaryWeapons.show()
	else:
		pass

func _on_secondary_weapons_button_pressed():
	if not $SecondaryWeapons.visible:
		$PrimaryWeapons.hide()
		$SecondaryWeapons.show()
	else:
		pass
