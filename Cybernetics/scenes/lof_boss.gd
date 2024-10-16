extends RayCast2D

@onready var main = get_node("/root/Main")

var burn_time : int
var burn_count : int

var is_casting_1: bool = false :
	set(value):
		if is_casting_2:
			pass
		else:
			is_casting_1 = value
			
			if is_casting_1:
				$Line2D.default_color = Color(0,255,255,255)
				$Line2D.self_modulate = Color(0,255,255,255)
				appear()
			else:
				disapear()
				
			set_physics_process(is_casting_1)

var is_casting_2: bool = false :
	set(value): 
		if is_casting_1:
			pass
		else:
			is_casting_2 = value
			
			if is_casting_2:
				$Line2D.default_color = Color(255,80,0,255)
				$Line2D.self_modulate = Color(255,80,0,255)
				appear()
			else:
				disapear()
			
			set_physics_process(is_casting_2)
		
func _ready():
	$Line2D.points[1] = global_position
	is_casting_1 = false
	is_casting_2 = false

func _process(_delta):
	var cast_point_1 := target_position
	force_raycast_update()
	
	if is_colliding():
		if is_casting_1:
			cast_point_1 = to_local(get_collision_point())
		else:
			if cast_point_1.x > 500:
				cast_point_1.x = 500
			else:
				cast_point_1 = to_local(get_collision_point())
	else:
		if is_casting_1:
			cast_point_1.x = 5000
		else:
			cast_point_1.x = 500
		
	target_position = cast_point_1
	
	is_casting_1 = get_parent().get_parent().lazer_activated
	is_casting_2 = get_parent().get_parent().flame_thrower_activated

func _physics_process(_delta):
	var cast_point_2 := target_position
	force_raycast_update()
	
	if is_colliding():
		cast_point_2 = to_local(get_collision_point())
		if get_collider().name == "Player":
			if is_casting_1:
				if $HitTimer2.is_stopped():
					main.hit_player_10_lazer()
					$HitTimer2.start()
			else:
				if $HitTimer2.is_stopped():
					main.hit_player_10_flame_thrower()
					$HitTimer2.start()
				if $BurnTimer.is_stopped():
					burn_count = 0
					burn_time = randi_range(5, 10)
					$BurnTimer.start()
		else:
			$HitTimer2.stop()
	else:
		$HitTimer2.stop()
	
	$Line2D.points[1] = cast_point_2

func _on_hit_timer_2_timeout():
	if is_casting_1:
		main.hit_player_10_lazer()
	else:
		main.hit_player_10_flame_thrower()

func _on_burn_timer_timeout():
	if burn_count < burn_time:
		main.hit_player_10_flame_thrower()
		burn_count += 1
	else:
		$BurnTimer.stop()

func appear() -> void:
	var tween = create_tween()
	
	if is_casting_1:
		tween.tween_property($Line2D, "width", 10.0, 0.2)
	else:
		tween.tween_property($Line2D, "width", 15.0, 0.2)

func disapear() -> void:
	var tween = create_tween()
	tween.tween_property($Line2D, "width", 0, 0.1)
