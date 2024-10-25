extends SubViewport

@onready var camera = $Camera2D
@onready var enemy_marker = $EnemyMarker
@onready var alert_marker = $AlertMarker
@onready var player = get_node("/root/Main/Player")

@onready var icons = {
	"enemy": enemy_marker,
	"alert": alert_marker
}

var markers = {}
var null_obj := "null_obj"

const RADIUS := 250

#represents minimap functionality by firstly constantly updating the camera position to follow the
#player position so the user knows where they are. secondly adding markers by getting all current 
#objects under the minimap objects group which are enemies and items and creating a new marker on the
#minimap for each one by constantly iterating through the map_objects array and checking if the minimap
#object doesn't already have a marker. the position of the marker is then clamped into a circle around
#the player marker as the minimap is a pentagon shape all so the player can see all the alive enemies
#and items on the minimap even when they're not in the frame so the end user has more information of 
#their surroundings. also delets a marker if the object it's representing dies or is deleted from the
#tree as seen from the for loop at the bottom so the player is aware of what's around them of important
#as for example an alive enemy is more important than a dead enemy
func _process(_delta):
	camera.position = player.position
	
	var map_objects = get_tree().get_nodes_in_group("minimap_objects")
	for object in map_objects:
		if object.marker_added:
			pass
		else:
			var new_marker = icons[object.minimap_icon].duplicate()
			
			if object.is_in_group("boss"):
				new_marker.scale = Vector2(2.5, 2.5)
			
			self.add_child(new_marker)
			markers[object] = new_marker
			new_marker.show()
			
			object.marker_added = true
		
		var obj_pos = object.position
		var player_pos = player.global_transform.origin
		var distance = player_pos.distance_to(obj_pos)
		var obj_dir = (obj_pos-player_pos).normalized()
		if distance > RADIUS:
			obj_pos = player_pos + (obj_dir * RADIUS)
		
		markers[object].global_transform.origin = obj_pos
	
	for key in markers:
		if key == null:
			markers[null_obj] = markers[key]
			markers[null_obj].queue_free()
			markers.erase(null_obj)
			markers.erase(key)
		elif key.minimap_icon == "enemy":
			if not key.alive:
				markers[key].hide()
			else:
				markers[key].show()
		else:
			pass
