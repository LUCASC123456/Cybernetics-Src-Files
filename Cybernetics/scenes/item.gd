extends Area2D

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")
@onready var health_bar = get_node("/root/Main/UI/HealthBar")
@onready var ammo_counter = get_node("/root/Main/UI/AmmoCounter/AmmoLabel")
@onready var reload_timer = get_node("/root/Main/Player/ReloadTimer")
@onready var shot_timer_pistol = get_node("/root/Main/Player/ShotTimerPistol")
@onready var shot_timer_smg = get_node("/root/Main/Player/ShotTimerSMG")
@onready var shot_timer_lmg = get_node("/root/Main/Player/ShotTimerLMG")
@onready var shot_timer_ar = get_node("/root/Main/Player/ShotTimerAR")

var item_type : int # 0: health, 1: ammo

#Basic item drops
var health_box = preload("res://assets/Items/SimpleHealth.png")
var ammo_box = preload("res://assets/Items/SimpleAmmo.png")
var textures = [health_box, ammo_box]

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = textures[item_type]

func _on_body_entered(body):
	if item_type == 0:
		if main.health < 100:
			main.health += randi_range(10, 75)
			if main.health >= 100:
				main.health = 100
				health_bar.value = main.health
			else:
				health_bar.value = main.health
			queue_free()
		else:
			pass
	elif item_type == 1:
		if player.selected_gun == "PISTOL":
			if reload_timer.is_stopped() == true and shot_timer_pistol.is_stopped() == true and player.mag_collection[2] < 15:
				body.ammo_gained()
				queue_free()
			else:
				pass
		elif player.selected_gun == "SMG":
			if reload_timer.is_stopped() == true and shot_timer_smg.is_stopped() == true and player.mag_collection[2] < 18:
				body.ammo_gained()
				queue_free()
			else:
				pass
		elif player.selected_gun == "LMG":
			if reload_timer.is_stopped() == true and shot_timer_lmg.is_stopped() == true and player.mag_collection[2] < 50:
				body.ammo_gained()
				queue_free()
			else:
				pass
		elif player.selected_gun == "AR":
			if reload_timer.is_stopped() == true and shot_timer_ar.is_stopped() == true and player.mag_collection[2] < 30:
				body.ammo_gained()
				queue_free()
			else:
				pass
