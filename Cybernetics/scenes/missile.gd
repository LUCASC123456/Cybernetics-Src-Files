extends Area2D

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")

@export var explosion_scene : PackedScene = null

var target : CharacterBody2D

var speed := 0.0
var current_velocity := Vector2.ZERO

const ACCELERATION := 425

#the rate at which the missile realigns itself to its desired velocity direction for realistic missile
#behaviour
var drag_factor := 0.025 : 
	set = set_drag_factor

#when entering the tree, makes sure the target is the player so it follows the player and nothing else
func _ready():
	target = player

#creates a direction variable every frame that points in the direction the missile has rotated to and
#updates it by then pointing it to the target relative to the missile so the missile knows where the
#target is to simulate a realistic homing missile. if the speed isn't already 800, accelerate to that
#speed through the acceleration constant every delta for realistic missile movement. create variable
#desired velocity which is the velocity the missile is trying to gain in the direction of the target
#while constantly adding the change variable which stores the different in the current and desired
#velocity or how far apart they are multiplied by the drag factor which represents how fast the current
#velocity will change or turn per frame to get to the desired velocity, add this to the current velocity every
#frame and use it for the actualy missile movement while forcing the missile to look in the direction
#of the current veloicty all for realistic missile movement
func _physics_process(delta: float) -> void:
	var direction := Vector2.RIGHT.rotated(rotation).normalized()
	
	if target:
		direction = global_position.direction_to(target.global_position)
	
	if speed < 850:
		speed += ACCELERATION * delta
	else:
		speed = 850
	
	var desired_velocity := direction * speed
	var change = (desired_velocity - current_velocity) * drag_factor
	
	current_velocity += change
	
	global_position += current_velocity * delta
	look_at(global_position + current_velocity)

#make sure the drag factor isn't below 0.01 and 0.05 for a limit to the drag
func set_drag_factor(new_value: float) -> void:
	drag_factor = clamp(new_value, 0.01, 0.5)

#instantiate the explostion scene by giving it properties e.g. positon for realistic missile behaviour
func _on_body_entered(_body):
	var explosion_area = explosion_scene.instantiate()
	get_tree().current_scene.call_deferred("add_child", explosion_area)
	explosion_area.global_position = global_position
	queue_free()

#instantiate the explostion scene by giving it properties e.g. positon for realistic missile behaviour
func _on_area_entered(_area):
	var explosion_area = explosion_scene.instantiate()
	get_tree().current_scene.call_deferred("add_child", explosion_area)
	explosion_area.global_position = global_position
	queue_free()

#missile deletes itself after a certain amount of time to reduce lag
func _on_timer_timeout():
	queue_free()
