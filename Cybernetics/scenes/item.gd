extends Area2D

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")
@onready var ui = get_node("/root/Main/UI")

#Basic drops
var health_box = preload("res://assets/Items/SimpleHealth.png")
var sheild_box = preload("res://assets/Items/SimpleSheild.png")
var ammo_box = preload("res://assets/Items/SimpleAmmo.png")

#Powerups
var boost = preload("res://assets/Items/SimpleBoost.png")
var force_field = preload("res://assets/Items/SimpleForceField.png")
var double_damage = preload("res://assets/Items/SimpleDoubleDamage.png")

var textures = [health_box, sheild_box, ammo_box, boost, force_field, double_damage]

var item_type : int 

var minimap_icon = "alert"
var marker_added : bool

func _ready():
	$Sprite2D.texture = textures[item_type]

func _on_body_entered(_body):
	if item_type == 0:
		if player.health < 200:
			player.health += randi_range(10, 75)
			if player.health >= 200:
				player.health = 200
			else:
				pass
				
			queue_free()
		else:
			pass
	elif item_type == 1:
		if player.sheild < 200:
			player.sheild += randi_range(10, 75)
			if player.sheild >= 200:
				player.sheild = 200
			else:
				pass
				
			queue_free()
		else:
			pass
	elif item_type == 2:
		if player.get_node("ReloadTimer").is_stopped():
			if player.selected_gun == "PISTOL":
				if player.mag_collection[2] < 15:
					if player.get_node("ShotTimerPistol").is_stopped():
						player.ammo_gained()
						queue_free()
					else:
						pass
				else:
					pass
			elif player.selected_gun == "SMG":
				if player.mag_collection[2] < 18:
					if player.get_node("ShotTimerSMG").is_stopped():
						player.ammo_gained()
						queue_free()
					else:
						pass
				else:
					pass
			elif player.selected_gun == "LMG":
				if player.mag_collection[2] < 50:
					if player.get_node("ShotTimerLMG").is_stopped():
						player.ammo_gained()
						queue_free()
					else:
						pass
				else:
					pass
			elif player.selected_gun == "AR":
				if player.mag_collection[2] < 30:
					if player.get_node("ShotTimerAR").is_stopped():
						player.ammo_gained()
						queue_free()
					else:
						pass
				else:
					pass
			else:
				pass
	elif item_type == 3:
		if not player.force_field_activated and not player.double_damage_activated:
			player.boost_activated = true
			
			if player.get_node("BoostTimer").is_stopped():
				player.get_node("BoostTimer").start(randi_range(5, 10))
			else:
				player.get_node("BoostTimer").start(player.get_node("BoostTimer").time_left + randi_range(5, 10))
			
			queue_free()
		else:
			pass
	elif item_type == 4:
		if not player.boost_activated and not player.double_damage_activated:
			player.force_field_activated = true
			
			if player.get_node("ForceFieldTimer").is_stopped():
				player.get_node("ForceFieldTimer").start(randi_range(5, 10))
			else:
				player.get_node("ForceFieldTimer").start(player.get_node("ForceFieldTimer").time_left + randi_range(5, 10))
					
			queue_free()
		else:
			pass
	elif item_type == 5:
		if not player.boost_activated and not player.force_field_activated:
			player.double_damage_activated = true
			
			if player.get_node("DoubleDamageTimer").is_stopped():
				player.get_node("DoubleDamageTimer").start(randi_range(5, 10))
			else:
				player.get_node("DoubleDamageTimer").start(player.get_node("DoubleDamageTimer").time_left + randi_range(5, 10))
					
			queue_free()
		else:
			pass
