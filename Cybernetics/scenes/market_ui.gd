extends CanvasLayer

@onready var main_menu = get_node("/root/Main/MainMenu")
@onready var not_enough_credits = get_node("/root/Main/NotEnoughCredits")
@onready var market = get_node("/root/Main/MarketUI")
@onready var buttons = market.get_child(6)

var pistol_price = 0
var smg_price = 400
var lmg_price = 1000
var ar_price = 600

# Called when the node enters the scene tree for the first time.
func _ready():
	main_menu.load_data()
	for item in range(buttons.get_child_count()):
		if main_menu.store.bought[item] == true:
			buttons.get_node("Button" + str(item+1)).text = "EQUIP"
	buttons.get_node("Button" + str(main_menu.store.selected+1)).text = "EQUIPPED"
	buttons.get_node("Button" + str(main_menu.store.selected+1)).add_to_group("selected")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _selected(node, no):
	main_menu.load_data()
	for button in get_tree().get_nodes_in_group("selected"):
		button.text = "EQUIP"
		button.remove_from_group("selected")
	node.text = "EQUIPPED"
	node.add_to_group("selected")
	main_menu.store.selected = no
	main_menu.save_data()

func _buy(price, item_no):
	main_menu.load_data()
	if main_menu.store.bought[item_no] == false:
		if main_menu.credits >= price:
			main_menu.credits -= price
			main_menu.store.bought[item_no] = true
			buttons.get_node("Button" + str(item_no+1)).text = "EQUIP"
			market.get_child(5).text = "CREDITS AVAILABLE: " + str(main_menu.credits)
			main_menu.save_data()
		else:
			var rem = price - main_menu.credits
			not_enough_credits.get_child(1).text = "YOU NEED " + str(rem) + " MORE CREDITS\n TO PURCHASE THIS ITEM"
			not_enough_credits.show()
	else:
		_selected(buttons.get_node("Button" + str(item_no+1)), item_no)


func _on_exit_button_pressed():
	market.hide()
	main_menu.show()

func _on_button_1_pressed():
	_buy(pistol_price, 0)

func _on_button_2_pressed():
	_buy(smg_price, 1)

func _on_button_3_pressed():
	_buy(lmg_price, 2)

func _on_button_4_pressed():
	_buy(ar_price, 3)
