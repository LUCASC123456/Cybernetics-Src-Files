extends Node2D

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")
@onready var space_state = get_world_2d().direct_space_state

var i : int
var FOV_increment = 2 * PI / 60

func _ready():
	i = int(name.lstrip("TargetNode2D"))
	print(i)
	
func draw_target_area(position):
	if main.mafia_enforcer_5s[i].alive:
		$LazerReachArea.monitoring = true
		$LazerReachArea/CollisionPolygon2D.disabled = false
		set_target_area(get_FOV_circle(position,500))
	else:
		$LazerReachArea.monitoring = false
		$LazerReachArea/CollisionPolygon2D.disabled = true
		set_target_area(get_FOV_circle(position,0))
		
func get_FOV_circle(from:Vector2,radius):
	return raycast_arc(from,radius,FOV_increment,2*PI)
	
func raycast_arc(from:Vector2,radius,start_angle,end_angle):
	var angle = start_angle	
	var points = PackedVector2Array()
	while angle < end_angle:
		var offset = Vector2(radius,0).rotated(angle)
		var to = from + offset
		var params = PhysicsRayQueryParameters2D.new()
		params.from = from
		params.to = to
		params.exclude = []
		params.collision_mask = 1 + 4
		
		var result = space_state.intersect_ray(params)
		if result:
			points.append(result.position)
		else:
			points.append(to)
		angle += FOV_increment
	return points
		
func set_target_area(points:PackedVector2Array):
	$LazerReachArea/TargetArea.polygon = points
	$LazerReachArea/CollisionPolygon2D.polygon = points

func _on_lazer_reach_area_body_entered(_body):
	main.mafia_enforcer_5s[i].lazer_reach = true

func _on_lazer_reach_area_body_exited(_body):
	if get_tree().paused == false:
		main.mafia_enforcer_5s[i].lazer_reach = false
	else:
		pass
