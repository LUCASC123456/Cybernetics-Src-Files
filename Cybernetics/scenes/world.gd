extends TileMap

@onready var main = get_node("/root/Main")

var passage_way : String
var level_exit_door_closed : bool

#Identify when exit door is closed for each level
func _process(_delta):
	if main.levels[0] or main.levels[1] or main.levels[2] or main.levels[3] or main.levels[4]:
		if main.enemies_left == 0:
			level_exit_door_closed = false
		else:
			level_exit_door_closed = true
	else:
		pass


#Level 1
func _on_level_1_body_entered(body):
	if body.name == "Player":
		main.levels[0] = true
		body.out_of_bounds = false
	else:
		pass
	
func _on_level_1_body_exited(body):
	if body.name == "Player":
		if passage_way == "passage_way_1_entered":
			main.levels[0] = false
			
			for i in $Level1.get_children():
				i.set_deferred("disabled", true)
			
			for i in $Level2.get_children():
				i.set_deferred("disabled", false)
			
			$ExitDoorTimer.start()
		else:
			body.out_of_bounds = true
	else:
		pass

func _on_passage_way_1_body_entered(_body):
	passage_way = "passage_way_1_entered"

func _on_passage_way_1_body_exited(_body):
	passage_way = "passage_way_1_exited"

func _on_level_1_area_entered(area):
	if area.is_in_group("out_of_bounds_checker"):
		area.get_parent().out_of_bounds = false
	else:
		pass

func _on_level_1_area_exited(area):
	if area.is_in_group("out_of_bounds_checker"):
		area.get_parent().out_of_bounds = true
	else:
		pass


#Level 2
func _on_level_2_body_entered(body):
	if body.name == "Player":
		main.levels[1] = true
		body.out_of_bounds = false
		main.new_game()
	else:
		pass

func _on_level_2_body_exited(body):
	if body.name == "Player":
		if passage_way == "passage_way_2_entered":
			main.levels[1] = false
			
			for i in $Level2.get_children():
				i.set_deferred("disabled", true)
				
			for i in $Level3.get_children():
				i.set_deferred("disabled", false)
			
			$ExitDoorTimer.start()
		else:
			body.out_of_bounds = true
	else:
		pass

func _on_passage_way_2_body_entered(_body):
	passage_way = "passage_way_2_entered"

func _on_passage_way_2_body_exited(_body):
	passage_way = "passage_way_2_exited"
	
func _on_level_2_area_entered(area):
	if area.is_in_group("out_of_bounds_checker"):
		area.get_parent().out_of_bounds = false
	else:
		pass

func _on_level_2_area_exited(area):
	if area.is_in_group("out_of_bounds_checker"):
		area.get_parent().out_of_bounds = true
	else:
		pass


#Level 3
func _on_level_3_body_entered(body):
	if body.name == "Player":
		main.levels[2] = true
		body.out_of_bounds = false
		main.new_game()
	else:
		pass

func _on_level_3_body_exited(body):
	if body.name == "Player":
		if passage_way == "passage_way_3_entered":
			main.levels[2] = false
			
			for i in $Level3.get_children():
				i.set_deferred("disabled", true)
				
			for i in $Level4.get_children():
				i.set_deferred("disabled", false)
			
			$ExitDoorTimer.start()
		else:
			body.out_of_bounds = true
	else:
		pass

func _on_passage_way_3_body_entered(_body):
	passage_way = "passage_way_3_entered"

func _on_passage_way_3_body_exited(_body):
	passage_way = "passage_way_3_exited"

func _on_level_3_area_entered(area):
	if area.is_in_group("out_of_bounds_checker"):
		area.get_parent().out_of_bounds = false
	else:
		pass

func _on_level_3_area_exited(area):
	if area.is_in_group("out_of_bounds_checker"):
		area.get_parent().out_of_bounds = true
	else:
		pass


#Level 4
func _on_level_4_body_entered(body):
	if body.name == "Player":
		main.levels[3] = true
		body.out_of_bounds = false
		main.new_game()
	else:
		pass
	
func _on_level_4_body_exited(body):
	if body.name == "Player":
		if passage_way == "passage_way_4_entered":
			main.levels[3] = false
			
			for i in $Level4.get_children():
				i.set_deferred("disabled", true)
				
			for i in $Level5.get_children():
				i.set_deferred("disabled", false)
			
			$ExitDoorTimer.start()
		else:
			body.out_of_bounds = true
	else:
		pass

func _on_passage_way_4_body_entered(_body):
	passage_way = "passage_way_4_entered"

func _on_passage_way_4_body_exited(_body):
	passage_way = "passage_way_4_exited"
	
func _on_level_4_area_entered(area):
	if area.is_in_group("out_of_bounds_checker"):
		area.get_parent().out_of_bounds = false
	else:
		pass

func _on_level_4_area_exited(area):
	if area.is_in_group("out_of_bounds_checker"):
		area.get_parent().out_of_bounds = true
	else:
		pass


#Level 5
func _on_level_5_body_entered(body):
	if body.name == "Player":
		body.out_of_bounds = false
		main.levels[4] = true
		main.new_game()
	else:
		pass

func _on_level_5_body_exited(body):
	if body.name == "Player":
		body.out_of_bounds = true
	else:
		pass

func _on_level_5_area_entered(area):
	if area.is_in_group("out_of_bounds_checker"):
		area.get_parent().out_of_bounds = false
	else:
		pass

func _on_level_5_area_exited(area):
	if area.is_in_group("out_of_bounds_checker"):
		area.get_parent().out_of_bounds = true
	else:
		pass


#Close exit doors
func _on_exit_door_timer_timeout():
	if passage_way == "passage_way_1_entered" or passage_way == "passage_way_1_exited":
		for tile_coord in main.player_door_coordinates["Level1"]:
			if tile_coord == Vector2i(15,5):
				set_cell(1, tile_coord, 7, Vector2i(0, 10), 0)
			else:
				set_cell(1, tile_coord, 7, Vector2i(0,16), 0)
	elif passage_way == "passage_way_2_entered" or passage_way == "passage_way_2_exited":
		for tile_coord_array in main.player_door_coordinates["Level2"]:
			for tile_coord in tile_coord_array:
				if tile_coord == Vector2i(24,5):
					set_cell(1, tile_coord, 7, Vector2i(0,11), 0)
				elif tile_coord == Vector2i(55,5):
					set_cell(1, tile_coord, 7, Vector2i(0,10), 0)
				else:
					set_cell(1, tile_coord, 7, Vector2i(0,16), 0)
	elif passage_way == "passage_way_3_entered" or passage_way == "passage_way_3_exited":
		for tile_coord_array in main.player_door_coordinates["Level3"]:
			for tile_coord in tile_coord_array:
				if tile_coord == Vector2i(65,19) or tile_coord == Vector2i(65,48):
					set_cell(1, tile_coord, 7, Vector2i(0,17), 0)
				elif tile_coord == Vector2i(68,19) or tile_coord == Vector2i(68,48):
					set_cell(1, tile_coord, 7, Vector2i(0,18), 0)
				else:
					set_cell(1, tile_coord, 7, Vector2i(0,19), 0)
	elif passage_way == "passage_way_4_entered" or passage_way == "passage_way_4_exited":
		for tile_coord_array in main.player_door_coordinates["Level4"]:
			for tile_coord in tile_coord_array:
				if tile_coord == Vector2i(127,48) or tile_coord == Vector2i(167,48):
					set_cell(1, tile_coord, 7, Vector2i(0,17), 0)
				elif tile_coord == Vector2i(130,48) or tile_coord == Vector2i(170,48):
					set_cell(1, tile_coord, 7, Vector2i(0,18), 0)
				else:
					set_cell(1, tile_coord, 7, Vector2i(0,19), 0)
	
	level_exit_door_closed = true
