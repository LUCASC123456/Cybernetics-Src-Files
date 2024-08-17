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
var can_shoot : bool
var screen_size_max : Vector2
var screen_size_min : Vector2
var mags : int
var selected_gun : String
var guns = [
	"PISTOL",
	"SMG",
	"LMG",
	"AR"
]

var mag_collection = [0,0,0]

func _ready():
	screen_size_min.x = 0
	screen_size_min.y = 0
	screen_size_max.x = 768
	screen_size_max.y = 768
	position = screen_size_max/2
	main_menu.load_data()
	reset()

func reset():
	selected_gun = guns[main_menu.store.selected]
	speed = 250
	mags = 3
	if selected_gun == "PISTOL":
		mag_collection[0] = 15
		mag_collection[1] = 15
		mag_collection[2] = 15
		ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/15 \nMAGS: " + str(mags) + "/3"
	elif selected_gun == "SMG":
		mag_collection[0] = 18
		mag_collection[1] = 18
		mag_collection[2] = 18
		ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/18 \nMAGS: " + str(mags) + "/3"
	elif selected_gun == "LMG":
		mag_collection[0] = 50
		mag_collection[1] = 50
		mag_collection[2] = 50
		ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/50 \nMAGS: " + str(mags) + "/3"
	elif selected_gun == "AR":
		mag_collection[0] = 30
		mag_collection[1] = 30
		mag_collection[2] = 30
		ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/30 \nMAGS: " + str(mags) + "/3"
	can_shoot = true

func get_input():
	#keyboard input
	var input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir.normalized() * speed
	
	if selected_gun == "PISTOL":
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_shoot and UI.entered == false:
			mag_collection[mags-1] -= 1
			if game_won.credits_earned > 0:
				game_won.credits_earned -= 2
				if game_won.credits_earned < 0:
					game_won.credits_earned = 0
				else:
					pass
			else:
				pass
			ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/15 \nMAGS: " + str(mags) + "/3"
			var dir = get_global_mouse_position() - position
			shoot.emit(position, dir)
			can_shoot = false
			if mag_collection[mags-1] > 0:
				$ShotTimerPistol.start()
			else:
				$ReloadTimer.start()
				ammo_counter.text = "RELOADING"
				
	elif selected_gun == "SMG":
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_shoot and UI.entered == false:
			mag_collection[mags-1] -= 1
			if game_won.credits_earned > 0:
				game_won.credits_earned -= 2
				if game_won.credits_earned < 0:
					game_won.credits_earned = 0
				else:
					pass
			else:
				pass
			ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/18 \nMAGS: " + str(mags) + "/3"
			var dir = get_global_mouse_position() - position
			shoot.emit(position, dir)
			can_shoot = false
			if mag_collection[mags-1] > 0:
				$ShotTimerSMG.start()
			else:
				$ReloadTimer.start()
				ammo_counter.text = "RELOADING"
	
	elif selected_gun == "LMG":
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_shoot and UI.entered == false:
			mag_collection[mags-1] -= 1
			if game_won.credits_earned > 0:
				game_won.credits_earned -= 2
				if game_won.credits_earned < 0:
					game_won.credits_earned = 0
				else:
					pass
			else:
				pass
			ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/50 \nMAGS: " + str(mags) + "/3"
			var dir = get_global_mouse_position() - position
			shoot.emit(position, dir)
			can_shoot = false
			if mag_collection[mags-1] > 0:
				$ShotTimerLMG.start()
			else:
				$ReloadTimer.start()
				ammo_counter.text = "RELOADING"
	
	elif selected_gun == "AR":
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_shoot and UI.entered == false:
			mag_collection[mags-1] -= 1
			if game_won.credits_earned > 0:
				game_won.credits_earned -= 2
				if game_won.credits_earned < 0:
					game_won.credits_earned = 0
				else:
					pass
			else:
				pass
			ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/30 \nMAGS: " + str(mags) + "/3"
			var dir = get_global_mouse_position() - position
			shoot.emit(position, dir)
			can_shoot = false
			if mag_collection[mags-1] > 0:
				$ShotTimerAR.start()
			else:
				$ReloadTimer.start()
				ammo_counter.text = "RELOADING"

func _physics_process(_delta):
	#player movement
	get_input()
	move_and_slide()
	
	#limit movement to window size
	if main.levels[0] == true:
		screen_size_min.x = 0
		screen_size_min.y = 0
		screen_size_max.x = 868
		screen_size_max.y = 768
		position = position.clamp(screen_size_min, screen_size_max)
		$AnimatedSprite2D/Camera2D.limit_left = 0
		$AnimatedSprite2D/Camera2D.limit_top = 0
		$AnimatedSprite2D/Camera2D.limit_right = 1536
		$AnimatedSprite2D/Camera2D.limit_bottom = 768
	elif main.levels[1] == true:
		screen_size_min.x = 1052
		screen_size_min.y = 0
		screen_size_max.x = 2788
		screen_size_max.y = 768
		position = position.clamp(screen_size_min, screen_size_max)
		$AnimatedSprite2D/Camera2D.limit_left = 384
		$AnimatedSprite2D/Camera2D.limit_top = 0
		$AnimatedSprite2D/Camera2D.limit_right = 3456
		$AnimatedSprite2D/Camera2D.limit_bottom = 768
	elif main.levels[2] == true:
		screen_size_min.x = 1680
		screen_size_min.y = 812
		screen_size_max.x = 4752
		screen_size_max.y = 2452
		position = position.clamp(screen_size_min, screen_size_max)
		$AnimatedSprite2D/Camera2D.limit_left = 1680
		$AnimatedSprite2D/Camera2D.limit_top = 144
		$AnimatedSprite2D/Camera2D.limit_right = 4752
		$AnimatedSprite2D/Camera2D.limit_bottom = 3120
	elif main.levels[3] == true:
		screen_size_min.x = 5856
		screen_size_min.y = 912
		screen_size_max.x = 8400
		screen_size_max.y = 2452
		position = position.clamp(screen_size_min, screen_size_max)
		$AnimatedSprite2D/Camera2D.limit_left = 5856
		$AnimatedSprite2D/Camera2D.limit_top = 912
		$AnimatedSprite2D/Camera2D.limit_right = 8400
		$AnimatedSprite2D/Camera2D.limit_bottom = 3120
	elif main.levels[4] == true:
		screen_size_min.x = 7008
		screen_size_min.y = 2924
		screen_size_max.x = 9216
		screen_size_max.y = 6768
		position = position.clamp(screen_size_min, screen_size_max)
		$AnimatedSprite2D/Camera2D.limit_left = 7008
		$AnimatedSprite2D/Camera2D.limit_top = 2256
		$AnimatedSprite2D/Camera2D.limit_right = 9216
		$AnimatedSprite2D/Camera2D.limit_bottom = 6768
	elif main.levels[0] == false and main.levels[1] == false and main.levels[2] == false and main.levels[3] == false and main.levels[4] == false:
		screen_size_min.x = 0
		screen_size_min.y = 0
		screen_size_max.x = 9216
		screen_size_max.y = 6768
		position = position.clamp(screen_size_min, screen_size_max)
		$AnimatedSprite2D/Camera2D.limit_left = 0
		$AnimatedSprite2D/Camera2D.limit_top = 0
		$AnimatedSprite2D/Camera2D.limit_right = 9216
		$AnimatedSprite2D/Camera2D.limit_bottom = 6768
	
	#player rotation
	var mouse = get_local_mouse_position()
	var angle = snappedf(mouse.angle(), PI/4) / (PI/4)
	angle = wrapi(int(angle), 0, 8)
	
	$AnimatedSprite2D.animation = "walk" + str(angle)
	
	#player animation
	if velocity.length() != 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.frame = 1
	
func ammo_gained():
	if selected_gun == "PISTOL":
		if mags == 3:
			if mag_collection[mags-1] == 15:
				pass
			else:
				mag_collection[mags-1] += randi_range(1, 15-mag_collection[mags-1])
				ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/15 \nMAGS: " + str(mags) + "/3"
		elif mags > 0 and mags < 3:
			mag_collection[mags-1] += randi_range(1,15)
			if mag_collection[mags-1] > 15:
				mag_collection[mags] = mag_collection[mags-1] - 15
				mag_collection[mags-1] = 15
				mags += 1
				ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/15 \nMAGS: " + str(mags) + "/3"
			else:
				ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/15 \nMAGS: " + str(mags) + "/3"
		elif mags == 0:
			mags += 1
			mag_collection[mags-1] += randi_range(1, 15)
			ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/15 \nMAGS: " + str(mags) + "/3"
			can_shoot = true

	elif selected_gun == "SMG":
		if mags == 3:
			if mag_collection[mags-1] == 18:
				pass
			else:
				mag_collection[mags-1] += randi_range(1, 18-mag_collection[mags-1])
				ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/18 \nMAGS: " + str(mags) + "/3"
		elif mags > 0 and mags < 3:
			mag_collection[mags-1] += randi_range(1,18)
			if mag_collection[mags-1] > 18:
				mag_collection[mags] = mag_collection[mags-1] - 18
				mag_collection[mags-1] = 18
				mags += 1
				ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/18 \nMAGS: " + str(mags) + "/3"
			else:
				ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/18 \nMAGS: " + str(mags) + "/3"
		elif mags == 0:
			mags += 1
			mag_collection[mags-1] += randi_range(1, 18)
			ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/18 \nMAGS: " + str(mags) + "/3"
			can_shoot = true
	elif selected_gun == "LMG":
		if mags == 3:
			if mag_collection[mags-1] == 50:
				pass
			else:
				mag_collection[mags-1] += randi_range(1, 50-mag_collection[mags-1])
				ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/50 \nMAGS: " + str(mags) + "/3"
		elif mags > 0 and mags < 3:
			mag_collection[mags-1] += randi_range(1,50)
			if mag_collection[mags-1] > 50:
				mag_collection[mags] = mag_collection[mags-1] - 50
				mag_collection[mags-1] = 50
				mags += 1
				ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/50 \nMAGS: " + str(mags) + "/3"
			else:
				ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/50 \nMAGS: " + str(mags) + "/3"
		elif mags == 0:
			mags += 1
			mag_collection[mags-1] += randi_range(1, 50)
			ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/50 \nMAGS: " + str(mags) + "/3"
			can_shoot = true
	elif selected_gun == "AR":
		if mags == 3:
			if mag_collection[mags-1] == 30:
				pass
			else:
				mag_collection[mags-1] += randi_range(1, 30-mag_collection[mags-1])
				ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/30 \nMAGS: " + str(mags) + "/3"
		elif mags > 0 and mags < 3:
			mag_collection[mags-1] += randi_range(1,30)
			if mag_collection[mags-1] > 30:
				mag_collection[mags] = mag_collection[mags-1] - 30
				mag_collection[mags-1] = 30
				mags += 1
				ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/30 \nMAGS: " + str(mags) + "/3"
			else:
				ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/30 \nMAGS: " + str(mags) + "/3"
		elif mags == 0:
			mags += 1
			mag_collection[mags-1] += randi_range(1, 30)
			ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/30 \nMAGS: " + str(mags) + "/3"
			can_shoot = true

func _on_reload_timer_timeout():
	if selected_gun == "PISTOL":
		mags -= 1
		if mags > 0:
			mag_collection[mags-1] = 15
			ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/15 \nMAGS: " + str(mags) + "/3"
			can_shoot = true
		else:
			ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/15 \nMAGS: " + str(mags) + "/3"
			can_shoot = false
			
	elif selected_gun == "SMG":
		mags -= 1
		if mags > 0:
			mag_collection[mags-1] = 18
			ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/18 \nMAGS: " + str(mags) + "/3"
			can_shoot = true
		else:
			ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/18 \nMAGS: " + str(mags) + "/3"
			can_shoot = false
			
	elif selected_gun == "LMG":
		mags -= 1
		if mags > 0:
			mag_collection[mags-1] = 50
			ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/50 \nMAGS: " + str(mags) + "/3"
			can_shoot = true
		else:
			ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/50 \nMAGS: " + str(mags) + "/3"
			can_shoot = false
			
	elif selected_gun == "AR":
		mags -= 1
		if mags > 0:
			mag_collection[mags-1] = 30
			ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/30 \nMAGS: " + str(mags) + "/3"
			can_shoot = true
		else:
			ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/30 \nMAGS: " + str(mags) + "/3"
			can_shoot = false
			
	
func _on_shot_timer_pistol_timeout():
	can_shoot = true

func _on_shot_timer_smg_timeout():
	can_shoot = true
	
func _on_shot_timer_lmg_timeout():
	can_shoot = true

func _on_shot_timer_ar_timeout():
	can_shoot = true
