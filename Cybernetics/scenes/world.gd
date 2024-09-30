extends TileMap

@onready var main = get_node("/root/Main")

var passage_way : String
var door_closed : bool
	
func _on_level_1_body_entered(body):
	if body.name == "Player":
		body.out_of_bounds = false
		main.levels[0] = true
		door_closed = false
	else:
		pass
	
func _on_level_1_body_exited(body):
	if body.name == "Player":
		if body.position.x >= 745:
			main.levels[0] = false
			
			for i in $Level1.get_children():
				i.set_deferred("disabled", true)
			for i in $Level2.get_children():
				i.set_deferred("disabled", false)
			
			passage_way = "passage_way_1"
			
			$ExitDoorTimer.start()
		elif body.position.y <= 23:
			body.out_of_bounds = true
		elif body.position.y >= 745:
			body.out_of_bounds = true
		else:
			pass
	else:
		pass

func _on_level_2_body_entered(body):
	if body.name == "Player":
		body.out_of_bounds = false
		main.levels[1] = true
		door_closed = false
		main.new_game()
	else:
		pass

func _on_level_2_body_exited(body):
	if body.name == "Player":
		if body.position.x >= 2665:
			main.levels[1] = false
			
			for i in $Level2.get_children():
				i.set_deferred("disabled", true)
			for i in $Level3.get_children():
				i.set_deferred("disabled", false)
			
			passage_way = "passage_way_2"
			
			$ExitDoorTimer.start()
		elif body.position.x <= 1175:
			body.out_of_bounds = true
		elif body.position.y <= 23:
			body.out_of_bounds = true
		elif body.position.y >= 745:
			body.out_of_bounds = true
		else:
			pass
	else:
		pass
	
func _on_level_3_body_entered(body):
	if body.name == "Player":
		body.out_of_bounds = false
		main.levels[2] = true
		door_closed = false
		main.new_game()
	else:
		pass

func _on_level_3_body_exited(body):
	if body.name == "Player":
		if body.position.y >= 2377:
			main.levels[2] = false
			
			for i in $Level3.get_children():
				i.set_deferred("disabled", true)
			for i in $Level4.get_children():
				i.set_deferred("disabled", false)
				
			passage_way = "passage_way_3"
			
			$ExitDoorTimer.start()
		elif body.position.y <= 935:
			body.out_of_bounds = true
		elif body.position.x <= 1703:
			body.out_of_bounds = true
		elif body.position.x >= 4729:
			body.out_of_bounds = true
		else:
			pass
	else:
		pass

func _on_level_4_body_entered(body):
	if body.name == "Player":
		body.out_of_bounds = false
		main.levels[3] = true
		door_closed = false
		main.new_game()
	else:
		pass
	
func _on_level_4_body_exited(body):
	if body.name == "Player":
		if body.position.x >= 8041 and body.position.x <= 8183 and body.position.y >= 2377:
			main.levels[3] = false
			
			for i in $Level4.get_children():
				i.set_deferred("disabled", true)
			for i in $Level5.get_children():
				i.set_deferred("disabled", false)
				
			passage_way = "passage_way_4"
			
			$ExitDoorTimer.start()
		elif body.position.x <= 5879:
			body.out_of_bounds = true
		elif body.position.x >= 8377:
			body.out_of_bounds = true
		elif body.positon.y <= 935:
			body.out_of_bounds = true
		else:
			pass
	else:
		pass

func _on_level_5_body_entered(body):
	if body.name == "Player":
		body.out_of_bounds = false
		main.levels[4] = true
		main.new_game()
	else:
		pass

func _on_level_5_body_exited(body):
	if body.name == "Player":
		pass
	else:
		pass


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


func _on_exit_door_timer_timeout():
	if passage_way == "passage_way_1":
		for i in main.player_door_coordinates["Level1"]:
			set_cell(1, i, 0, Vector2i(0,0), 0)
	elif passage_way == "passage_way_2":
		for i in main.player_door_coordinates["Level2"][1]:
			set_cell(1, i, 0, Vector2i(0,0), 0)
	elif passage_way == "passage_way_3":
		for i in main.player_door_coordinates["Level3"][1]:
			set_cell(1, i, 0, Vector2i(0,0), 0)
	elif passage_way == "passage_way_4":
		for i in main.player_door_coordinates["Level4"][1]:
			set_cell(1, i, 0, Vector2i(0,0), 0)
	
	door_closed = true
