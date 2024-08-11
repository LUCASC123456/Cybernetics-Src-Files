extends CanvasLayer

@onready var not_enough_credits = get_node("/root/Main/NotEnoughCredits")
@onready var market = get_node("/root/Main/MarketUI")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_ok_button_pressed():
	not_enough_credits.hide()
	market.show()
