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

#when the market scene first enters the tree, load the user data and iterate through each array storing
#the primary and secondary buttons by making their text say "SELECt", then find the selected primary
#and secondary weapon and based on its index in the selected array, use this index to change the index
#of PWButtons and SWButtons to "SELECTED" so the end user knows which weapon they have selected
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
	
#constantly update the credits available text in case something happens to the amount of credits the
#end user has
func _process(_delta):
	$CreditsAvailable.text = "CREDITS AVAILABLE: " + str(main_menu.credits)

#firstly load the data so the script knows which weapon is currently selected then
#changes the text of the button which the user has already selected to "SELECT", 
#then based on the parameters change the text of the button the user pressed to
#"SELECTED", then save this data so the selected weapon saves and the end user can
#select weapons
func _select_primary(node, no):
	main_menu.load_data()
	
	for button in get_tree().get_nodes_in_group("primary_selected"):
		button.text = "SELECT"
		button.remove_from_group("primary_selected")
	
	node.text = "SELECTED"
	node.add_to_group("primary_selected")
	main_menu.primary_store.selected = no
	main_menu.save_data()

#firstly load the data so the script knows which weapon is currently selected then
#changes the text of the button which the user has already selected to "SELECT", 
#then based on the parameters change the text of the button the user pressed to
#"SELECTED", then save this data so the selected weapon saves and the end user can
#select weapons
func _select_secondary(node, no):
	main_menu.load_data()
	
	for button in get_tree().get_nodes_in_group("secondary_selected"):
		button.text = "SELECT"
		button.remove_from_group("secondary_selected")
	
	node.text = "SELECTED"
	node.add_to_group("secondary_selected")
	main_menu.secondary_store.selected = no
	main_menu.save_data()

#loads the data firstly so the amount of credits are available and if the weapon the end user is trying
#to buy is already bought based on the loaded data, simple select that weapon, otherwise if the user
#has enought credits, minus the price of the weapon from the credits, add change it to true in the bought
#array and change its text to "SELECT" to allow the end user to select it, otherwise show the not enought
#credits screen all so the end user can buy new weapons, select them and be notified that they need
#more credits to purchase the weapon
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

#loads the data firstly so the amount of credits are available and if the weapon the end user is trying
#to buy is already bought based on the loaded data, simple select that weapon, otherwise if the user
#has enought credits, minus the price of the weapon from the credits, add change it to true in the bought
#array and change its text to "SELECT" to allow the end user to select it, otherwise show the not enought
#credits screen all so the end user can buy new weapons, select them and be notified that they need
#more credits to purchase the weapon
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

#when the user presses the exit button the market ui hides and the main menu ui shows so the user can
#go back to the main menu whenver they want
func _on_exit_button_pressed():
	hide()
	main_menu.show()

#when the user presses this button, buy the weapon through the buy function so the user can simply 
#use mouse click to buy a new weapon as they'd expect
func _on_pw_button_1_pressed():
	_buy_primary(pistol_price, 0)

#when the user presses this button, buy the weapon through the buy function so the user can simply 
#use mouse click to buy a new weapon as they'd expect
func _on_pw_button_2_pressed():
	_buy_primary(smg_price, 1)

#when the user presses this button, buy the weapon through the buy function so the user can simply 
#use mouse click to buy a new weapon as they'd expect
func _on_pw_button_3_pressed():
	_buy_primary(lmg_price, 2)

#when the user presses this button, buy the weapon through the buy function so the user can simply 
#use mouse click to buy a new weapon as they'd expect
func _on_pw_button_4_pressed():
	_buy_primary(ar_price, 3)


#when the user presses this button, buy the weapon through the buy function so the user can simply 
#use mouse click to buy a new weapon as they'd expect
func _on_sw_button_1_pressed():
	_buy_secondary(pistol_price, 0)

#when the user presses this button, buy the weapon through the buy function so the user can simply 
#use mouse click to buy a new weapon as they'd expect
func _on_sw_button_2_pressed():
	_buy_secondary(mp_price, 1)

#hides the secondary weapons section and shows the primary weapons section if the primary weapons
#section isn't already visible, also changes the image of the button to show the end user they're in
#the primary weapons section
func _on_primary_weapons_button_pressed():
	if not $PrimaryWeapons.visible:
		$SecondaryWeapons.hide()
		$PrimaryWeapons.show()
		
		$PrimaryWeaponsButton.texture_normal = ResourceLoader.load("res://assets/MarketUI/WeaponsButtonPressed.png")
		$SecondaryWeaponsButton.texture_normal = ResourceLoader.load("res://assets/MarketUI/WeaponsButton.png")
	else:
		pass

#hides the primary weapons section and shows the secondary weapons section if the secondary weapons
#section isn't already visible, also changes the image of the button to show the end user they're in
#the secondary weapons section
func _on_secondary_weapons_button_pressed():
	if not $SecondaryWeapons.visible:
		$PrimaryWeapons.hide()
		$SecondaryWeapons.show()
		
		$SecondaryWeaponsButton.texture_normal = ResourceLoader.load("res://assets/MarketUI/WeaponsButtonPressed.png")
		$PrimaryWeaponsButton.texture_normal = ResourceLoader.load("res://assets/MarketUI/WeaponsButton.png")
	else:
		pass
