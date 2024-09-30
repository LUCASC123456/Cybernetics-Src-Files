extends Camera2D

@onready var main = get_node("/root/Main")

func _process(_delta):
	if get_tree().paused:
		limit_left = 0
		limit_top = 0
		limit_right = 10000
		limit_bottom = 10000
		
		position_smoothing_enabled = false
		drag_horizontal_enabled = false
		drag_vertical_enabled = false
	else:
		position_smoothing_enabled = true
		drag_horizontal_enabled = true
		drag_vertical_enabled = true
		
		if main.levels[0]:
			limit_left = 0
			limit_top = 0
			limit_right = 1536
			limit_bottom = 768
		elif main.levels[1]:
			limit_left = 384
			limit_top = 0
			limit_right = 3456
			limit_bottom = 768
		elif main.levels[2]: 
			limit_left = 1680
			limit_top = 144
			limit_right = 4752
			limit_bottom = 3120
		elif main.levels[3]:
			limit_left = 5856
			limit_top = 912
			limit_right = 8400
			limit_bottom = 3120
		elif main.levels[4]:
			limit_left = 7008
			limit_top = 2256
			limit_right = 9216
			limit_bottom = 6768
		else:
			limit_left = 0
			limit_top = 0
			limit_right = 10000
			limit_bottom = 10000
