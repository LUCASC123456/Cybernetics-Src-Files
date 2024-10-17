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

var item_type : int 
var entered : bool

var health_box = preload("res://assets/Items/SimpleHealth.png")
var ammo_box = preload("res://assets/Items/SimpleAmmo.png")
var textures = [health_box, ammo_box]

var minimap_icon = "alert"
var marker_added : bool

func _ready():
	entered = false
	$Sprite2D.texture = textures[item_type]

func _process(_delta):
	if entered:
		_on_body_entered(player)

func _on_body_entered(body):
	entered = true
	if item_type == 0:
		if player.health < 100:
			player.health += randi_range(10, 75)
			if player.health >= 100:
				player.health = 100
				health_bar.value = player.health
			else:
				health_bar.value = player.health
			queue_free()
		else:
			pass
	elif item_type == 1:
		if player.selected_gun == "PISTOL":
			if reload_timer.is_stopped() and shot_timer_pistol.is_stopped() and player.mag_collection[2] < 15:
				body.ammo_gained()
				queue_free()
			else:
				pass
		elif player.selected_gun == "SMG":
			if reload_timer.is_stopped() and shot_timer_smg.is_stopped() and player.mag_collection[2] < 18:
				body.ammo_gained()
				queue_free()
			else:
				pass
		elif player.selected_gun == "LMG":
			if reload_timer.is_stopped() and shot_timer_lmg.is_stopped() and player.mag_collection[2] < 50:
				body.ammo_gained()
				queue_free()
			else:
				pass
		elif player.selected_gun == "AR":
			if reload_timer.is_stopped() and shot_timer_ar.is_stopped() and player.mag_collection[2] < 30:
				body.ammo_gained()
				queue_free()
			else:
				pass
		

func _on_body_exited(_body):
	entered = false
