extends CharacterBody2D

@onready var main = get_node("/root/Main")
@onready var ammo_counter = get_node("/root/Main/UI/Hotbar/AmmoCounter/AmmoLabel")
@onready var UI = get_node("/root/Main/UI")
@onready var game_won = get_node("/root/Main/GameWon")
@onready var main_menu = get_node("/root/Main/MainMenu")
@onready var market = get_node("/root/Main/MarketUI")
@onready var world = get_node("/root/Main/World")
@onready var sword = $Sword

signal shoot

var speed : int
var primary_mags : int
var secondary_mags : int
var health : int
var sheild : int
var can_shoot : bool
var out_of_bounds : bool
var primary_equipped : bool
var boost_activated : bool
var force_field_activated : bool
var double_damage_activated : bool
var primary_selected_gun : String
var secondary_selected_gun : String

var primary_guns = ["PISTOL", "SMG", "LMG", "AR"]
var secondary_guns = ["PISTOL", "MP"]
var primary_mag_collection = [0,0,0]
var secondary_mag_collection = [0,0,0]

func _ready():
	speed = 250
	position = Vector2(384, 384)
	
	main_menu.load_data()
	primary_selected_gun = primary_guns[main_menu.primary_store.selected]
	secondary_selected_gun = secondary_guns[main_menu.secondary_store.selected]
	can_shoot = true
	
	boost_activated = false
	$BoostTimer.stop()
	
	force_field_activated = false
	$ForceFieldTimer.stop()
	
	double_damage_activated = false
	$DoubleDamageTimer.stop()
	
	reset()

func reset():
	health = 200
	sheild = 200
	primary_mags = 3
	secondary_mags = 3
	primary_equipped = true
	
	if primary_selected_gun == "PISTOL":
		for i in range(0, len(primary_mag_collection)):
			primary_mag_collection[i] = 15
	elif primary_selected_gun == "SMG":
		for i in range(0, len(primary_mag_collection)):
			primary_mag_collection[i] = 20
	elif primary_selected_gun == "LMG":
		for i in range(0, len(primary_mag_collection)):
			primary_mag_collection[i] = 50
	elif primary_selected_gun == "AR":
		for i in range(0, len(primary_mag_collection)):
			primary_mag_collection[i] = 30
	else:
		pass
	
	if secondary_selected_gun == "PISTOL":
		for i in range(0, len(secondary_mag_collection)):
			secondary_mag_collection[i] = 15
	elif secondary_selected_gun == "MP":
		for i in range(0, len(secondary_mag_collection)):
			secondary_mag_collection[i] = 20
	else:
		pass

func get_input():
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_dir.normalized() * speed
	
	if Input.is_action_pressed("primary_weapon"):
		if not primary_equipped:
			primary_equipped = true
			
			UI.get_node("Hotbar/PrimaryWeaponSelection").texture_normal = ResourceLoader.load("res://assets/GamePlayUI/PrimaryWeaponSelectionSelected.png")
			UI.get_node("Hotbar/SecondaryWeaponSelection").texture_normal = ResourceLoader.load("res://assets/GamePlayUI/SecondaryWeaponSelection.png")
			
			if not $ReloadTimerSecondary.is_stopped():
				$ReloadTimerSecondary.stop()
			else:
				pass
			
			can_shoot = true
		else:
			pass
	elif Input.is_action_just_pressed("secondary_weapon"):
		if primary_equipped:
			primary_equipped = false
			
			UI.get_node("Hotbar/SecondaryWeaponSelection").texture_normal = ResourceLoader.load("res://assets/GamePlayUI/SecondaryWeaponSelectionSelected.png")
			UI.get_node("Hotbar/PrimaryWeaponSelection").texture_normal = ResourceLoader.load("res://assets/GamePlayUI/PrimaryWeaponSelection.png")
			
			if not $ReloadTimerPrimary.is_stopped():
				$ReloadTimerPrimary.stop()
			else:
				pass
			
			can_shoot = true
		else:
			pass
	else:
		pass
	
	if primary_equipped:
		if primary_selected_gun == "PISTOL":
			if Input.is_action_just_pressed("shoot") and can_shoot:
				if not UI.ui_mouse_entered:
					if primary_mag_collection[primary_mags-1] > 0:
						main.bullets_fired += 1
						primary_mag_collection[primary_mags-1] -= 1
						
						if main.credits_earned > 0:
							main.credits_earned -= 2
							if main.credits_earned < 0:
								main.credits_earned = 0
							else:
								pass
						else:
							pass
							
						var dir = get_global_mouse_position() - position
						var angle = randf_range(dir.angle()+PI/60, dir.angle()-PI/60)
						
						dir = Vector2(cos(angle), sin(angle))
						shoot.emit(position, dir)
						can_shoot = false
						
						$ShotTimerPistol.start()
					else:
						if $ReloadTimerPrimary.is_stopped():
							$ReloadTimerPrimary.start()
						else:
							pass
				else:
					pass
			else:
				pass
				
		elif primary_selected_gun == "SMG":
			if Input.is_action_pressed("shoot") and can_shoot:
				if not UI.ui_mouse_entered:
					if primary_mag_collection[primary_mags-1] > 0:
						main.bullets_fired += 1
						primary_mag_collection[primary_mags-1] -= 1
						
						if main.credits_earned > 0:
							main.credits_earned -= 2
							if main.credits_earned < 0:
								main.credits_earned = 0
							else:
								pass
						else:
							pass
						
						var dir = get_global_mouse_position() - position
						var angle = randf_range(dir.angle()+PI/60, dir.angle()-PI/60)
						
						dir = Vector2(cos(angle), sin(angle))
						shoot.emit(position, dir)
						can_shoot = false
						
						$ShotTimerSMG.start()
					else:
						if $ReloadTimerPrimary.is_stopped():
							$ReloadTimerPrimary.start()
						else:
							pass
				else:
					pass
			else:
				pass
				
		elif primary_selected_gun == "LMG":
			if Input.is_action_pressed("shoot") and can_shoot:
				if not UI.ui_mouse_entered:
					if primary_mag_collection[primary_mags-1] > 0:
						main.bullets_fired += 1
						primary_mag_collection[primary_mags-1] -= 1
						
						if main.credits_earned > 0:
							main.credits_earned -= 2
							if main.credits_earned < 0:
								main.credits_earned = 0
							else:
								pass
						else:
							pass
						
						var dir = get_global_mouse_position() - position
						var angle = randf_range(dir.angle()+PI/60, dir.angle()-PI/60)
						
						dir = Vector2(cos(angle), sin(angle))
						shoot.emit(position, dir)
						can_shoot = false
						
						$ShotTimerLMG.start()
					else:
						if $ReloadTimerPrimary.is_stopped():
							$ReloadTimerPrimary.start()
						else:
							pass
				else:
					pass
			else:
				pass
				
		elif primary_selected_gun == "AR":
			if Input.is_action_pressed("shoot") and can_shoot:
				if not UI.ui_mouse_entered:
					if primary_mag_collection[primary_mags-1] > 0:
						main.bullets_fired += 1
						primary_mag_collection[primary_mags-1] -= 1
						
						if main.credits_earned > 0:
							main.credits_earned -= 2
							if main.credits_earned < 0:
								main.credits_earned = 0
							else:
								pass
						else:
							pass
						
						var dir = get_global_mouse_position() - position
						var angle = randf_range(dir.angle()+PI/60, dir.angle()-PI/60)
						
						dir = Vector2(cos(angle), sin(angle))
						shoot.emit(position, dir)
						can_shoot = false
						
						$ShotTimerAR.start()
					else:
						if $ReloadTimerPrimary.is_stopped():
							$ReloadTimerPrimary.start()
						else:
							pass
				else:
					pass
			else:
				pass
	else:
		if secondary_selected_gun == "PISTOL":
			if Input.is_action_just_pressed("shoot") and can_shoot:
				if not UI.ui_mouse_entered:
					if secondary_mag_collection[secondary_mags-1] > 0:
						main.bullets_fired += 1
						secondary_mag_collection[secondary_mags-1] -= 1
						
						if main.credits_earned > 0:
							main.credits_earned -= 2
							if main.credits_earned < 0:
								main.credits_earned = 0
							else:
								pass
						else:
							pass
							
						var dir = get_global_mouse_position() - position
						var angle = randf_range(dir.angle()+PI/60, dir.angle()-PI/60)
						
						dir = Vector2(cos(angle), sin(angle))
						shoot.emit(position, dir)
						can_shoot = false
						
						$ShotTimerPistol.start()
					else:
						if $ReloadTimerSecondary.is_stopped():
							$ReloadTimerSecondary.start()
						else:
							pass
				else:
					pass
			else:
				pass
				
		elif secondary_selected_gun == "MP":
			if Input.is_action_pressed("shoot") and can_shoot:
				if not UI.ui_mouse_entered:
					if secondary_mag_collection[secondary_mags-1] > 0:
						main.bullets_fired += 1
						secondary_mag_collection[secondary_mags-1] -= 1
						
						if main.credits_earned > 0:
							main.credits_earned -= 2
							if main.credits_earned < 0:
								main.credits_earned = 0
							else:
								pass
						else:
							pass
							
						var dir = get_global_mouse_position() - position
						var angle = randf_range(dir.angle()+PI/60, dir.angle()-PI/60)
						
						dir = Vector2(cos(angle), sin(angle))
						shoot.emit(position, dir)
						can_shoot = false
					
						$ShotTimerMP.start()
					else:
						if $ReloadTimerSecondary.is_stopped():
							$ReloadTimerSecondary.start()
						else:
							pass
				else:
					pass
			else:
				pass
		
	if Input.is_action_just_pressed("melee"):
		if $SwordTimer.is_stopped():
			if get_local_mouse_position().angle() >= -PI/2 and get_local_mouse_position().angle() <= PI/2:
				sword.rotation = (get_local_mouse_position().angle()) - PI/2
				sword.swing_clockwise = true
			else:
				sword.rotation = (get_local_mouse_position().angle()) + PI/2
				sword.swing_clockwise = false
			
			sword.swinging = true
			
			$SwordTimer.start()
		else:
			pass
	else:
		pass

func _process(_delta):
	if primary_equipped:
		if primary_selected_gun == "PISTOL":
			if primary_mags != 0:
				if $ReloadTimerPrimary.is_stopped():
					ammo_counter.text = "AMMO: " + str(primary_mag_collection[primary_mags-1]) + "/15 \nMAGS: " + str(primary_mags) + "/3"
				else:
					ammo_counter.text = "RELOADING"
			else:
				primary_mag_collection[primary_mags] = 0
				ammo_counter.text = "AMMO: " + str(primary_mag_collection[primary_mags-1]) + "/15 \nMAGS: " + str(primary_mags) + "/3"
		elif primary_selected_gun == "SMG":
			if primary_mags != 0:
				if $ReloadTimerPrimary.is_stopped():
					ammo_counter.text = "AMMO: " + str(primary_mag_collection[primary_mags-1]) + "/20 \nMAGS: " + str(primary_mags) + "/3"
				else:
					ammo_counter.text = "RELOADING"
			else:
				primary_mag_collection[primary_mags] = 0
				ammo_counter.text = "AMMO: " + str(primary_mag_collection[primary_mags-1]) + "/20 \nMAGS: " + str(primary_mags) + "/3"
		elif primary_selected_gun == "LMG":
			if primary_mags != 0:
				if $ReloadTimerPrimary.is_stopped():
					ammo_counter.text = "AMMO: " + str(primary_mag_collection[primary_mags-1]) + "/50 \nMAGS: " + str(primary_mags) + "/3"
				else:
					ammo_counter.text = "RELOADING"
			else:
				primary_mag_collection[primary_mags] = 0
				ammo_counter.text = "AMMO: " + str(primary_mag_collection[primary_mags-1]) + "/50 \nMAGS: " + str(primary_mags) + "/3"
		elif primary_selected_gun == "AR":
			if primary_mags != 0:
				if $ReloadTimerPrimaryr.is_stopped():
					ammo_counter.text = "AMMO: " + str(primary_mag_collection[primary_mags-1]) + "/30 \nMAGS: " + str(primary_mags) + "/3"
				else:
					ammo_counter.text = "RELOADING"
			else:
				primary_mag_collection[primary_mags] = 0
				ammo_counter.text = "AMMO: " + str(primary_mag_collection[primary_mags-1]) + "/30 \nMAGS: " + str(primary_mags) + "/3"
		else:
			pass
	else:
		if secondary_selected_gun == "PISTOL":
			if secondary_mags != 0:
				if $ReloadTimerSecondary.is_stopped():
					ammo_counter.text = "AMMO: " + str(secondary_mag_collection[secondary_mags-1]) + "/15 \nMAGS: " + str(secondary_mags) + "/3"
				else:
					ammo_counter.text = "RELOADING"
			else:
				secondary_mag_collection[secondary_mags] = 0
				ammo_counter.text = "AMMO: " + str(secondary_mag_collection[secondary_mags-1]) + "/15 \nMAGS: " + str(secondary_mags) + "/3"
		elif secondary_selected_gun == "MP":
			if secondary_mags != 0:
				if $ReloadTimerSecondary.is_stopped():
					ammo_counter.text = "AMMO: " + str(secondary_mag_collection[secondary_mags-1]) + "/20 \nMAGS: " + str(secondary_mags) + "/3"
				else:
					ammo_counter.text = "RELOADING"
			else:
				secondary_mag_collection[secondary_mags] = 0
				ammo_counter.text = "AMMO: " + str(secondary_mag_collection[secondary_mags-1]) + "/20 \nMAGS: " + str(secondary_mags) + "/3"
		
func _physics_process(delta):
	get_input()
	move_and_slide()
	
	if main.levels[0]:
		if out_of_bounds:
			position = Vector2(384,384)
		else:
			pass
	elif main.levels[1]:
		if out_of_bounds:
			position = Vector2(1920,384)
		else:
			pass
	elif main.levels[2]:
		if out_of_bounds:
			position = Vector2(3216,1624)
		else:
			pass
	elif main.levels[3]:
		if out_of_bounds:
			position = Vector2(7128,1632)
		else:
			pass
	elif main.levels[4]:
		if out_of_bounds:
			position = Vector2(8112,4968)
		else:
			pass
	else:
		if world.level_exit_door_closed:
			if world.passage_way == "passage_way_1_exited":
				position = Vector2(843,384)
			elif world.passage_way == "passage_way_2_exited":
				position = Vector2(2763,384)
			elif world.passage_way == "passage_way_3_exited":
				position = Vector2(3216,2427)
			elif world.passage_way == "passage_way_4_exited":
				position = Vector2(8112,2427)
			else:
				pass
		else:
			pass
	
	var mouse = get_local_mouse_position()
	var angle = snappedf(mouse.angle(), PI/4) / (PI/4)
	angle = wrapi(int(angle), 0, 8)
	
	if boost_activated:
		speed = 500
	else:
		speed = 250
	
	$AnimatedSprite2D.animation = "walk" + str(angle)
	
	if velocity.length() != 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.frame = 1
	
func ammo_gained():
	if primary_equipped:
		if $ReloadTimerPrimary.is_stopped():
			if primary_selected_gun == "PISTOL":
				if $ShotTimerPistol.is_stopped():
					if primary_mags == 3:
						if primary_mag_collection[primary_mags-1] == 15:
							pass
						else:
							primary_mag_collection[primary_mags-1] += randi_range(1, 15-primary_mag_collection[primary_mags-1])
					elif primary_mags > 0 and primary_mags < 3:
						primary_mag_collection[primary_mags-1] += randi_range(1,15)
						if primary_mag_collection[primary_mags-1] > 15:
							primary_mags += 1
							primary_mag_collection[primary_mags-1] = primary_mag_collection[primary_mags-2] - 15
							primary_mag_collection[primary_mags-2] = 15
						else:
							pass
					elif primary_mags == 0:
						primary_mags += 1
						primary_mag_collection[primary_mags-1] += randi_range(1, 15)
						can_shoot = true
				else:
					pass
			
			elif primary_selected_gun == "SMG":
				if $ShotTimerSMG.is_stopped():
					if primary_mags == 3:
						if primary_mag_collection[primary_mags-1] == 20:
							pass
						else:
							primary_mag_collection[primary_mags-1] += randi_range(1, 20-primary_mag_collection[primary_mags-1])
					elif primary_mags > 0 and primary_mags < 3:
						primary_mag_collection[primary_mags-1] += randi_range(1,20)
						if primary_mag_collection[primary_mags-1] > 20:
							primary_mags += 1
							primary_mag_collection[primary_mags-1] = primary_mag_collection[primary_mags-2] - 20
							primary_mag_collection[primary_mags-2] = 20
						else:
							pass
					elif primary_mags == 0:
						primary_mags += 1
						primary_mag_collection[primary_mags-1] += randi_range(1, 20)
						can_shoot = true
				else:
					pass
			
			elif primary_selected_gun == "LMG":
				if $ShotTimerLMG.is_stopped():
					if primary_mags == 3:
						if primary_mag_collection[primary_mags-1] == 50:
							pass
						else:
							primary_mag_collection[primary_mags-1] += randi_range(1, 50-primary_mag_collection[primary_mags-1])
					elif primary_mags > 0 and primary_mags < 3:
						primary_mag_collection[primary_mags-1] += randi_range(1,50)
						if primary_mag_collection[primary_mags-1] > 50:
							primary_mags += 1
							primary_mag_collection[primary_mags-1] = primary_mag_collection[primary_mags-2] - 50
							primary_mag_collection[primary_mags-2] = 50
						else:
							pass
					elif primary_mags == 0:
						primary_mags += 1
						primary_mag_collection[primary_mags-1] += randi_range(1, 50)
						can_shoot = true
				else:
					pass
					
			elif primary_selected_gun == "AR":
				if $ShotTimerAR.is_stopped():
					if primary_mags == 3:
						if primary_mag_collection[primary_mags-1] == 30:
							pass
						else:
							primary_mag_collection[primary_mags-1] += randi_range(1, 30-primary_mag_collection[primary_mags-1])
					elif primary_mags > 0 and primary_mags < 3:
						primary_mag_collection[primary_mags-1] += randi_range(1,30)
						if primary_mag_collection[primary_mags-1] > 30:
							primary_mags += 1
							primary_mag_collection[primary_mags-1] = primary_mag_collection[primary_mags-2] - 30
							primary_mag_collection[primary_mags-2] = 30
						else:
							pass
					elif primary_mags == 0:
						primary_mags += 1
						primary_mag_collection[primary_mags-1] += randi_range(1, 30)
						can_shoot = true
				else:
					pass
			else:
				pass
		else:
			pass
	else:
		if $ReloadTimerSecondary.is_stopped():
			if secondary_selected_gun == "PISTOL":
				if $ShotTimerPistol.is_stopped():
					if secondary_mags == 3:
						if secondary_mag_collection[secondary_mags-1] == 15:
							pass
						else:
							secondary_mag_collection[secondary_mags-1] += randi_range(1, 15-secondary_mag_collection[secondary_mags-1])
					elif secondary_mags > 0 and secondary_mags < 3:
						secondary_mag_collection[secondary_mags-1] += randi_range(1,15)
						if secondary_mag_collection[secondary_mags-1] > 15:
							secondary_mags += 1
							secondary_mag_collection[secondary_mags-1] = secondary_mag_collection[secondary_mags-2] - 15
							secondary_mag_collection[secondary_mags-2] = 15
						else:
							pass
					elif secondary_mags == 0:
						secondary_mags += 1
						secondary_mag_collection[secondary_mags-1] += randi_range(1, 15)
						can_shoot = true
				else:
					pass
			elif secondary_selected_gun == "MP":
				if $ShotTimerPistol.is_stopped():
					if secondary_mags == 3:
						if secondary_mag_collection[secondary_mags-1] == 20:
							pass
						else:
							secondary_mag_collection[secondary_mags-1] += randi_range(1, 20-secondary_mag_collection[secondary_mags-1])
					elif secondary_mags > 0 and secondary_mags < 3:
						secondary_mag_collection[secondary_mags-1] += randi_range(1,20)
						if secondary_mag_collection[secondary_mags-1] > 20:
							secondary_mags += 1
							secondary_mag_collection[secondary_mags-1] = secondary_mag_collection[secondary_mags-2] - 20
							secondary_mag_collection[secondary_mags-2] = 20
						else:
							pass
					elif secondary_mags == 0:
						secondary_mags += 1
						secondary_mag_collection[secondary_mags-1] += randi_range(1, 20)
						can_shoot = true
				else:
					pass
			else:
				pass
		else:
			pass
		
func _on_reload_timer_primary_timeout():
	if primary_selected_gun == "PISTOL":
		primary_mags -= 1
		if primary_mags > 0:
			primary_mag_collection[primary_mags-1] = 15
			can_shoot = true
		else:
			can_shoot = false
			
	elif primary_selected_gun == "SMG":
		primary_mags -= 1
		if primary_mags > 0:
			primary_mag_collection[primary_mags-1] = 20
			can_shoot = true
		else:
			can_shoot = false
			
	elif primary_selected_gun == "LMG":
		primary_mags -= 1
		if primary_mags > 0:
			primary_mag_collection[primary_mags-1] = 50
			can_shoot = true
		else:
			can_shoot = false
			
	elif primary_selected_gun == "AR":
		primary_mags -= 1
		if primary_mags > 0:
			primary_mag_collection[primary_mags-1] = 30
			can_shoot = true
		else:
			can_shoot = false

func _on_reload_timer_secondary_timeout():
	if secondary_selected_gun == "PISTOL":
		secondary_mags -= 1
		if secondary_mags > 0:
			secondary_mag_collection[secondary_mags-1] = 15
			can_shoot = true
		else:
			can_shoot = false
	elif secondary_selected_gun == "MP":
		secondary_mags -= 1
		if secondary_mags > 0:
			secondary_mag_collection[secondary_mags-1] = 20
			can_shoot = true
		else:
			can_shoot = false


func _on_shot_timer_pistol_timeout():
	can_shoot = true

func _on_shot_timer_mp_timeout():
	can_shoot = true

func _on_shot_timer_smg_timeout():
	can_shoot = true

func _on_shot_timer_lmg_timeout():
	can_shoot = true

func _on_shot_timer_ar_timeout():
	can_shoot = true


func _on_sword_timer_timeout():
	sword.swinging = false


func _on_boost_timer_timeout():
	boost_activated = false

func _on_force_field_timer_timeout():
	force_field_activated = false

func _on_double_damage_timer_timeout():
	double_damage_activated = false
