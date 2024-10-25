extends Node2D

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")
@onready var space_state = get_world_2d().direct_space_state

var i : int
var FOV_increment = 2 * PI / 60

#when the node enters the tree, create an index for it by grabbing just the numbered part of it and
#converting it into type int as this node will be stored in an array and will be used to constantly
#be drawn around certain types of enemies in an array with a corresponding index to i
func _ready():
	i = int(name.lstrip("TargetNode2D"))

#there are two enemies which use a circular area region to spot the player and these are mafia enforcer
#5 and the boss which show up in the levels shows below, so if these levels are the current one, draw
#a target area node around one of these enemies based on which level it is in order for them to have
#a circular vision region around them
func draw_target_area(pos):
	if main.levels[3]:
		if main.mafia_enforcer_5s[i].alive:
			set_target_area(get_FOV_circle(pos,500))
		else:
			set_target_area(get_FOV_circle(pos,0))
	elif main.levels[1] or main.levels[4]:
		if main.boss.alive:
			set_target_area(get_FOV_circle(pos,1000))
		else:
			set_target_area(get_FOV_circle(pos,0))
	else:
		pass

#function that takes in the central point for the circular region and the radius it will have as these
#will be crucial factors when drawing the circle around the enemy as these two parameters are passed
#into the raycast_arc function which takes these variables as the first two parameters with the others
#being constant
func get_FOV_circle(from:Vector2,radius):
	return raycast_arc(from,radius,FOV_increment,2*PI)

#the function that actually draws the circle, does this by drawing out the radius of the circle and 
#incrementing the arc length and sector area each time the function runs if the angle is less that a
#full cycle, which is 2pi and adds these changes to a packed vector2 array which actually represents
#the circular area itself. this is all so the target area can constantly be updated and will even
#not draw over certain collision objects set by the mask below such as enemies and the walls which
#allows for extremely realistic vision by the enemy
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

#making the circular area visible and valid by making the collision polygon represent the circular
#area for detecting collisions while also assigning it to the target area to make it visible which is
#helpful for debugging
func set_target_area(points:PackedVector2Array):
	$VisionArea/TargetArea.polygon = points
	$VisionArea/CollisionPolygon2D.polygon = points

#enabling the can_see_player variable for each enemy that uses the target area node to enable certain
#functionality within these enemies
func _on_lazer_reach_area_body_entered(_body):
	if main.levels[3]:
		main.mafia_enforcer_5s[i].can_see_player = true
	elif main.levels[1] or main.levels[4]:
		main.boss.can_see_player = true
	else:
		pass

#disabling the can_see_player variable for each enemy that uses the target area node to disable certain
#functionality within these enemies
func _on_lazer_reach_area_body_exited(_body):
	if main.levels[3]:
		main.mafia_enforcer_5s[i].can_see_player = false
	elif main.levels[1] or main.levels[4]:
		main.boss.can_see_player = false
	else:
		pass
