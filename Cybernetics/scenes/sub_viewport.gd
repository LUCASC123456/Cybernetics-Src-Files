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

const radius := 250

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
		if distance > radius:
			obj_pos = player_pos + (obj_dir * radius)
		
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
