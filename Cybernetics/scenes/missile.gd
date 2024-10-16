extends Area2D

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")

@export var explosion_scene : PackedScene = null

var target : CharacterBody2D

var speed := 0.0
var current_velocity := Vector2.ZERO

const acceleration := 425

var drag_factor := 0.025 : 
	set = set_drag_factor

func _ready():
	target = player
	
func _physics_process(delta: float) -> void:
	var direction := Vector2.RIGHT.rotated(rotation).normalized()
	
	if target:
		direction = global_position.direction_to(target.global_position)
	
	if speed < 850:
		speed += acceleration * delta
	else:
		speed = 850
	
	var desired_velocity := direction * speed
	var change = (desired_velocity - current_velocity) * drag_factor
	
	current_velocity += change
	
	global_position += current_velocity * delta
	look_at(global_position + current_velocity)
	
func set_drag_factor(new_value: float) -> void:
	drag_factor = clamp(new_value, 0.01, 0.5)

func _on_body_entered(_body):
	var explosion_area = explosion_scene.instantiate()
	get_tree().current_scene.call_deferred("add_child", explosion_area)
	explosion_area.global_position = global_position
	queue_free()

func _on_area_entered(_area):
	var explosion_area = explosion_scene.instantiate()
	get_tree().current_scene.call_deferred("add_child", explosion_area)
	explosion_area.global_position = global_position
	queue_free()

func _on_timer_timeout():
	queue_free()
