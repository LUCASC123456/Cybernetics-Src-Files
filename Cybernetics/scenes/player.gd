extends CharacterBody2D

@onready var main = get_node("/root/Main")
@onready var ammo_counter = get_node("/root/Main/UI/AmmoCounter/AmmoLabel")
@onready var UI = get_node("/root/Main/UI")
@onready var game_won = get_node("/root/Main/GameWon")
@onready var main_menu = get_node("/root/Main/MainMenu")
@onready var market = get_node("/root/Main/MarketUI")
@onready var world = get_node("/root/Main/World")

signal shoot

var speed : int
var mags : int
var health : int
var can_shoot : bool
var out_of_bounds : bool
var selected_gun : String

var guns = ["PISTOL", "SMG", "LMG", "AR"]
var mag_collection = [0,0,0]

func _ready():
	speed = 250
	position = Vector2(384, 384)
	main_menu.load_data()
	selected_gun = guns[main_menu.store.selected]
	can_shoot = true
	reset()

func reset():
	health = 100
	mags = 3
	
	if selected_gun == "PISTOL":
		for i in range(0, len(mag_collection)):
			mag_collection[i] = 15
	elif selected_gun == "SMG":
		for i in range(0, len(mag_collection)):
			mag_collection[i] = 18
	elif selected_gun == "LMG":
		for i in range(0, len(mag_collection)):
			mag_collection[i] = 50
	elif selected_gun == "AR":
		for i in range(0, len(mag_collection)):
			mag_collection[i] = 30

func get_input():
	var input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir.normalized() * speed
	
	if selected_gun == "PISTOL":
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_shoot:
			if UI.ui_mouse_entered == false:
				mag_collection[mags-1] -= 1
				if main.credits_earned > 0:
					main.credits_earned -= 2
					if main.credits_earned < 0:
						main.credits_earned = 0
					else:
						pass
				else:
					pass
					
				var dir = get_global_mouse_position() - position
				shoot.emit(position, dir)
				can_shoot = false
				
				if mag_collection[mags-1] > 0:
					$ShotTimerPistol.start()
				else:
					$ReloadTimer.start()
			else:
				pass
				
	elif selected_gun == "SMG":
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_shoot:
			if UI.ui_mouse_entered == false:
				mag_collection[mags-1] -= 1
				if main.credits_earned > 0:
					main.credits_earned -= 2
					if main.credits_earned < 0:
						main.credits_earned = 0
					else:
						pass
				else:
					pass
			
				var dir = get_global_mouse_position() - position
				shoot.emit(position, dir)
				can_shoot = false
				
				if mag_collection[mags-1] > 0:
					$ShotTimerSMG.start()
				else:
					$ReloadTimer.start()
			else:
				pass
				
	elif selected_gun == "LMG":
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_shoot:
			if UI.ui_mouse_entered == false:
				mag_collection[mags-1] -= 1
				if main.credits_earned > 0:
					main.credits_earned -= 2
					if main.credits_earned < 0:
						main.credits_earned = 0
					else:
						pass
				else:
					pass
			
				var dir = get_global_mouse_position() - position
				shoot.emit(position, dir)
				can_shoot = false
				
				if mag_collection[mags-1] > 0:
					$ShotTimerLMG.start()
				else:
					$ReloadTimer.start()
			else:
				pass
				
	elif selected_gun == "AR":
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_shoot:
			if UI.ui_mouse_entered == false:
				mag_collection[mags-1] -= 1
				if main.credits_earned > 0:
					main.credits_earned -= 2
					if main.credits_earned < 0:
						main.credits_earned = 0
					else:
						pass
				else:
					pass
				
				var dir = get_global_mouse_position() - position
				shoot.emit(position, dir)
				can_shoot = false
				
				if mag_collection[mags-1] > 0:
					$ShotTimerAR.start()
				else:
					$ReloadTimer.start()
			else:
				pass

func _process(_delta):
	if selected_gun == "PISTOL":
		if mags != 0:
			if $ReloadTimer.is_stopped():
				ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/15 \nMAGS: " + str(mags) + "/3"
			else:
				ammo_counter.text = "RELOADING"
		else:
			mag_collection[mags] = 0
			ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/15 \nMAGS: " + str(mags) + "/3"
	elif selected_gun == "SMG":
		if mags != 0:
			if $ReloadTimer.is_stopped():
				ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/18 \nMAGS: " + str(mags) + "/3"
			else:
				ammo_counter.text = "RELOADING"
		else:
			mag_collection[mags] = 0
			ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/18 \nMAGS: " + str(mags) + "/3"
	elif selected_gun == "LMG":
		if mags != 0:
			if $ReloadTimer.is_stopped():
				ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/50 \nMAGS: " + str(mags) + "/3"
			else:
				ammo_counter.text = "RELOADING"
		else:
			mag_collection[mags] = 0
			ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/30 \nMAGS: " + str(mags) + "/3"
	elif selected_gun == "AR":
		if mags != 0:
			if $ReloadTimer.is_stopped():
				ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/30 \nMAGS: " + str(mags) + "/3"
			else:
				ammo_counter.text = "RELOADING"
		else:
			mag_collection[mags] = 0
			ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/50 \nMAGS: " + str(mags) + "/3"
	
func _physics_process(_delta):
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
		if world.passage_way == "passage_way_1":
			if world.exit_door_closed:
				if position.x < 793:
					position = Vector2(843,384)
				else:
					pass
			else:
				pass
		elif world.passage_way == "passage_way_2":
			if world.exit_door_closed:
				if position.x < 2713:
					position = Vector2(2763,384)
				else:
					pass
			else:
				pass
		elif world.passage_way == "passage_way_3":
			if world.exit_door_closed:
				if position.y < 2377:
					position = Vector2(3216,2427)
				else:
					pass
			else:
				pass
		elif world.passage_way == "passage_way_4":
			if world.exit_door_closed:
				if position.y < 2377:
					position = Vector2(8112,2427)
				else:
					pass
			else:
				pass
	
	var mouse = get_local_mouse_position()
	var angle = snappedf(mouse.angle(), PI/4) / (PI/4)
	angle = wrapi(int(angle), 0, 8)
	
	$AnimatedSprite2D.animation = "walk" + str(angle)
	
	if velocity.length() != 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.frame = 1
	
func ammo_gained():
	if $ReloadTimer.is_stopped():
		if selected_gun == "PISTOL":
			if $ShotTimerPistol.is_stopped():
				if mags == 3:
					if mag_collection[mags-1] == 15:
						pass
					else:
						mag_collection[mags-1] += randi_range(1, 15-mag_collection[mags-1])
				elif mags > 0 and mags < 3:
					mag_collection[mags-1] += randi_range(1,15)
					if mag_collection[mags-1] > 15:
						mags += 1
						mag_collection[mags-1] = mag_collection[mags-2] - 15
						mag_collection[mags-2] = 15
					else:
						pass
				elif mags == 0:
					mags += 1
					mag_collection[mags-1] += randi_range(1, 15)
					can_shoot = true
			else:
				pass

		elif selected_gun == "SMG":
			if $ShotTimerSMG.is_stopped():
				if mags == 3:
					if mag_collection[mags-1] == 18:
						pass
					else:
						mag_collection[mags-1] += randi_range(1, 18-mag_collection[mags-1])
				elif mags > 0 and mags < 3:
					mag_collection[mags-1] += randi_range(1,18)
					if mag_collection[mags-1] > 18:
						mags += 1
						mag_collection[mags-1] = mag_collection[mags-2] - 18
						mag_collection[mags-2] = 18
					else:
						pass
				elif mags == 0:
					mags += 1
					mag_collection[mags-1] += randi_range(1, 18)
					can_shoot = true
			else:
				pass
		
		elif selected_gun == "LMG":
			if $ShotTimerLMG.is_stopped():
				if mags == 3:
					if mag_collection[mags-1] == 50:
						pass
					else:
						mag_collection[mags-1] += randi_range(1, 50-mag_collection[mags-1])
				elif mags > 0 and mags < 3:
					mag_collection[mags-1] += randi_range(1,50)
					if mag_collection[mags-1] > 50:
						mags += 1
						mag_collection[mags-1] = mag_collection[mags-2] - 50
						mag_collection[mags-2] = 50
					else:
						pass
				elif mags == 0:
					mags += 1
					mag_collection[mags-1] += randi_range(1, 50)
					can_shoot = true
			else:
				pass
				
		elif selected_gun == "AR":
			if $ShotTimerAR.is_stopped():
				if mags == 3:
					if mag_collection[mags-1] == 30:
						pass
					else:
						mag_collection[mags-1] += randi_range(1, 30-mag_collection[mags-1])
				elif mags > 0 and mags < 3:
					mag_collection[mags-1] += randi_range(1,30)
					if mag_collection[mags-1] > 30:
						mags += 1
						mag_collection[mags-1] = mag_collection[mags-2] - 30
						mag_collection[mags-2] = 30
					else:
						pass
				elif mags == 0:
					mags += 1
					mag_collection[mags-1] += randi_range(1, 30)
					can_shoot = true
			else:
				pass
	else:
		pass

func _on_reload_timer_timeout():
	if selected_gun == "PISTOL":
		mags -= 1
		if mags > 0:
			mag_collection[mags-1] = 15
			can_shoot = true
		else:
			can_shoot = false
			
	elif selected_gun == "SMG":
		mags -= 1
		if mags > 0:
			mag_collection[mags-1] = 18
			can_shoot = true
		else:
			can_shoot = false
			
	elif selected_gun == "LMG":
		mags -= 1
		if mags > 0:
			mag_collection[mags-1] = 50
			can_shoot = true
		else:
			can_shoot = false
			
	elif selected_gun == "AR":
		mags -= 1
		if mags > 0:
			mag_collection[mags-1] = 30
			can_shoot = true
		else:
			can_shoot = false
	
func _on_shot_timer_pistol_timeout():
	can_shoot = true

func _on_shot_timer_smg_timeout():
	can_shoot = true
	
func _on_shot_timer_lmg_timeout():
	can_shoot = true

func _on_shot_timer_ar_timeout():
	can_shoot = true
