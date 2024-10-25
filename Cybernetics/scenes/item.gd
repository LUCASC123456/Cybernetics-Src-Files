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

#set the item texture to the designated type specified by the enemy when it died to let the player know
#which power up it is
func _ready():
	$Sprite2D.texture = textures[item_type]

func _on_body_entered(_body):
	if item_type == 0:
		#gain health if the players health isn't already 200 so they player earn more health and survive
		#longer
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
		#gain sheid if the players shield isn't already 200 so they player can earn more sheild and
		#survive longer
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
		#based whether the player has their priamry or secondary weapon equipped, and which primary
		#and secondary weapon they're using, gain ammo for that particular weapon if the ammo isn't
		#already full and the player is reloading or firing that weapon so the player can gain more
		#ammo and fire more shots
		if player.primary_equipped:
			if player.get_node("ReloadTimerPrimary").is_stopped():
				if player.primary_selected_gun == "PISTOL":
					if player.primary_mag_collection[2] < 15:
						if player.get_node("ShotTimerPistol").is_stopped():
							player.ammo_gained()
							queue_free()
						else:
							pass
					else:
						pass
				elif player.primary_selected_gun == "SMG":
					if player.primary_mag_collection[2] < 18:
						if player.get_node("ShotTimerSMG").is_stopped():
							player.ammo_gained()
							queue_free()
						else:
							pass
					else:
						pass
				elif player.primary_selected_gun == "LMG":
					if player.primary_mag_collection[2] < 50:
						if player.get_node("ShotTimerLMG").is_stopped():
							player.ammo_gained()
							queue_free()
						else:
							pass
					else:
						pass
				elif player.primary_selected_gun == "AR":
					if player.primary_mag_collection[2] < 30:
						if player.get_node("ShotTimerAR").is_stopped():
							player.ammo_gained()
							queue_free()
						else:
							pass
					else:
						pass
				else:
					pass
			else:
				pass
		else:
			if player.get_node("ReloadTimerSecondary").is_stopped():
				if player.secondary_selected_gun == "PISTOL":
					if player.secondary_mag_collection[2] < 15:
						if player.get_node("ShotTimerPistol").is_stopped():
							player.ammo_gained()
							queue_free()
						else:
							pass
					else:
						pass
				elif player.secondary_selected_gun == "MP":
					if player.secondary_mag_collection[2] < 15:
						if player.get_node("ShotTimerMP").is_stopped():
							player.ammo_gained()
							queue_free()
						else:
							pass
					else:
						pass
				else:
					pass
			else:
				pass
	elif item_type == 3:
		#if the other two power ups aren't currently being used by the player (to prevent overlapping),
		#give the player this particular powerup by adding time to its duration of usage so the player
		#can use powerups and add more time to its duration if they're already using this particular one
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
		#if the other two power ups aren't currently being used by the player (to prevent overlapping),
		#give the player this particular powerup by adding time to its duration of usage so the player
		#can use powerups and add more time to its duration if they're already using this particular one
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
		#if the other two power ups aren't currently being used by the player (to prevent overlapping),
		#give the player this particular powerup by adding time to its duration of usage so the player
		#can use powerups and add more time to its duration if they're already using this particular one
		if not player.boost_activated and not player.force_field_activated:
			player.double_damage_activated = true
			
			if player.get_node("DoubleDamageTimer").is_stopped():
				player.get_node("DoubleDamageTimer").start(randi_range(5, 10))
			else:
				player.get_node("DoubleDamageTimer").start(player.get_node("DoubleDamageTimer").time_left + randi_range(5, 10))
					
			queue_free()
		else:
			pass
