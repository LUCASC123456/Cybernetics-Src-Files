extends CharacterBody2D

@onready var ammo_counter = get_node("/root/Main/UI/AmmoCounter/AmmoLabel")
@onready var UI = get_node("/root/Main/UI")

signal shoot

var speed : int
var can_shoot : bool
var screen_size : Vector2
var mags : int

var mag_collection = [15,15,15]

func _ready():
	screen_size = get_viewport_rect().size
	reset()

func reset():
	position = screen_size/2
	speed = 200
	mags = 3
	mag_collection[0] = 15
	mag_collection[1] = 15
	mag_collection[2] = 15
	ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/15 MAGS: " + str(mags) + "/3"
	can_shoot = true

func get_input():
	#keyboard input
	var input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir.normalized() * speed
	
	#mouse clicks
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_shoot and UI.entered == false:
		mag_collection[mags-1] -= 1
		ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/15 MAGS: " + str(mags) + "/3"
		var dir = get_global_mouse_position() - position
		shoot.emit(position, dir)
		can_shoot = false
		if mag_collection[mags-1] > 0:
			$ShotTimer.start()
		else:
			$ReloadTimer.start()
		

func _physics_process(_delta):
	#player movement
	get_input()
	move_and_slide()
	
	#limit movement to window size
	position = position.clamp(Vector2.ZERO, screen_size)
	
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
	if mags == 3:
		if mag_collection[mags-1] == 15:
			pass
		else:
			mag_collection[mags-1] += randi_range(1, 15-mag_collection[mags-1])
			ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/15 MAGS: " + str(mags) + "/3"
	elif mags > 0 and mags < 3:
		mag_collection[mags-1] += randi_range(1,15)
		if mag_collection[mags-1] > 15:
			mag_collection[mags] = mag_collection[mags-1] - 15
			mag_collection[mags-1] = 15
			mags += 1
			ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/15 MAGS: " + str(mags) + "/3"
		else:
			ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/15 MAGS: " + str(mags) + "/3"
	elif mags == 0:
		mags += 1
		mag_collection[mags-1] += randi_range(1, 15)
		ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/15 MAGS: " + str(mags) + "/3"
		can_shoot = true

func _on_shot_timer_timeout():
	can_shoot = true

func _on_reload_timer_timeout():
	mags -= 1
	if mags > 0:
		mag_collection[mags-1] = 15
		ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/15 MAGS: " + str(mags) + "/3"
		can_shoot = true
	else:
		ammo_counter.text = "AMMO: " + str(mag_collection[mags-1]) + "/15 MAGS: " + str(mags) + "/3"
		can_shoot = false
