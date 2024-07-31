extends Area2D

@onready var main = get_node("/root/Main")
@onready var health_bar = get_node("/root/Main/UI/HealthBar")
@onready var ammo_counter = get_node("/root/Main/UI/AmmoCounter/AmmoLabel")

var item_type : int # 0: health, 1: ammo

#Basic item drops
var health_box = preload("res://assets/Items/SimpleHealth.png")
var ammo_box = preload("res://assets/Items/SimpleAmmo.png")
var textures = [health_box, ammo_box]

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = textures[item_type]

func _on_body_entered(body):
	#Health
	if item_type == 0:
		if main.health != 100:
			main.health += 10
			health_bar.value = main.health
		else:
			pass
	#Ammo
	elif item_type == 1:
		body.ammo_gained()
	#Delete item
	queue_free()
