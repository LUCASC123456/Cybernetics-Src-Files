extends RayCast2D

@onready var main = get_node("/root/Main")

var is_casting: bool = false :
	set(value): 
		is_casting = value
		
		if is_casting:
			appear()
		else:
			disapear()
		
		set_physics_process(is_casting)
		
func _ready():
	$Line2D.points[1] = Vector2.ZERO
	is_casting = false

func _process(_delta):
	var cast_point_1 := target_position
	force_raycast_update()
	
	if is_colliding():
		cast_point_1 = to_local(get_collision_point())
	else:
		cast_point_1.x = 5000
		
	target_position = cast_point_1
	
	is_casting = get_parent().lazer_activated

func _physics_process(_delta: float) -> void:
	var cast_point_2 := target_position
	force_raycast_update()
	
	if is_colliding():
		cast_point_2 = to_local(get_collision_point())
		if get_collider().name == "Player":
			main.hit_player_5_lazer()
			get_parent().speed = 100
			get_parent().lazer_activated = false
			get_parent().get_node("LazerBeamTimer").stop()
			get_parent().get_node("LazerBeamChanceTimer").start()
		else:
			pass
	else:
		pass
	
	$Line2D.points[1] = cast_point_2
		
func appear() -> void:
	var tween = create_tween()
	tween.tween_property($Line2D, "width", 10.0, 0.2)

func disapear() -> void:
	var tween = create_tween()
	tween.tween_property($Line2D, "width", 0, 0.1)
