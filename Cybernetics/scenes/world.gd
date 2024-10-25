extends TileMap

@onready var main = get_node("/root/Main")

var passage_way : String
var level_exit_door_closed : bool

#for every frame no matter the level, if there aren't any enemies left than open the exit doors, otherwise
#they're closed so the player can only leave once they've killed all the enemies
func _process(_delta):
	if main.levels[0] or main.levels[1] or main.levels[2] or main.levels[3] or main.levels[4]:
		if main.enemies_left == 0:
			level_exit_door_closed = false
		else:
			level_exit_door_closed = true
	else:
		pass


#checks if the body entered the level region is the player and if so, enable that speicifc level boolean
#which results in functionality exclusive to that level as well as ensuring the player isn't out of
#bounds all so that level functionality can occur and the player won't be constantly teleported into
#the centre of the map as a result of being out of bounds
func _on_level_1_body_entered(body):
	if body.name == "Player":
		main.levels[0] = true
		body.out_of_bounds = false
	else:
		pass

#Checks if the body exiting the level region is the player and if the exit is a specific door, stop 
#and that level functionality while disabling the level region and enabling the next level regions so
#the player can enter the next level, but cannot re enter the one it just completed so the same level
#doesn't start again. the exit door timer will also start which allows for the exits doors to close
#so the physically cannot re enter the level it just completed. in any other case when the player exits
#the map they're out of bounds which is why this variable is set to true
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

#when the player enters the passage between levels denote which one they're in in order to run certain
#events such as the exit doors closing
func _on_passage_way_1_body_entered(_body):
	passage_way = "passage_way_1_entered"

#in case the player leaves too soon, functionality such as the exit doors closing will still occur
#as long as the passage_way variable has anything to do with the particular level the exits doors are
#on in order fully ensure functionality such as this occurs
func _on_passage_way_1_body_exited(_body):
	passage_way = "passage_way_1_exited"

#used for enemies if they go out of bounds, if so, make this apparent so certain functionality can 
#occur such as teleporting them back in in so they can't leave
func _on_level_1_area_entered(area):
	if area.is_in_group("out_of_bounds_checker"):
		area.get_parent().out_of_bounds = false
	else:
		pass

#making sure to turn of the out_of_bounds boolean when an enemy re eneters so they aren't constantly
#being teleported into the centre of the map
func _on_level_1_area_exited(area):
	if area.is_in_group("out_of_bounds_checker"):
		area.get_parent().out_of_bounds = true
	else:
		pass


#checks if the body entered the level region is the player and if so, enable that speicifc level boolean
#which results in functionality exclusive to that level, ensure the player isn't out of bounds and reset
#the player all so that level functionality can occur and the player won't be constantly teleported
#into the centre of the map as a result of being out of bounds as well as making sure the player is
#reset and prepared for the next level 
func _on_level_2_body_entered(body):
	if body.name == "Player":
		main.levels[1] = true
		body.out_of_bounds = false
		main.new_game()
	else:
		pass

#Checks if the body exiting the level region is the player and if the exit is a specific door, stop 
#and that level functionality while disabling the level region and enabling the next level regions so
#the player can enter the next level, but cannot re enter the one it just completed so the same level
#doesn't start again. the exit door timer will also start which allows for the exits doors to close
#so the physically cannot re enter the level it just completed. in any other case when the player exits
#the map they're out of bounds which is why this variable is set to true
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

#when the player enters the passage between levels denote which one they're in in order to run certain
#events such as the exit doors closing
func _on_passage_way_2_body_entered(_body):
	passage_way = "passage_way_2_entered"

#in case the player leaves too soon, functionality such as the exit doors closing will still occur
#as long as the passage_way variable has anything to do with the particular level the exits doors are
#on in order fully ensure functionality such as this occurs
func _on_passage_way_2_body_exited(_body):
	passage_way = "passage_way_2_exited"

#used for enemies if they go out of bounds, if so, make this apparent so certain functionality can 
#occur such as teleporting them back in in so they can't leave
func _on_level_2_area_entered(area):
	if area.is_in_group("out_of_bounds_checker"):
		area.get_parent().out_of_bounds = false
	else:
		pass

#making sure to turn of the out_of_bounds boolean when an enemy re eneters so they aren't constantly
#being teleported into the centre of the map
func _on_level_2_area_exited(area):
	if area.is_in_group("out_of_bounds_checker"):
		area.get_parent().out_of_bounds = true
	else:
		pass


#checks if the body entered the level region is the player and if so, enable that speicifc level boolean
#which results in functionality exclusive to that level, ensure the player isn't out of bounds and reset
#the player all so that level functionality can occur and the player won't be constantly teleported
#into the centre of the map as a result of being out of bounds as well as making sure the player is
#reset and prepared for the next level 
func _on_level_3_body_entered(body):
	if body.name == "Player":
		main.levels[2] = true
		body.out_of_bounds = false
		main.new_game()
	else:
		pass

#Checks if the body exiting the level region is the player and if the exit is a specific door, stop 
#and that level functionality while disabling the level region and enabling the next level regions so
#the player can enter the next level, but cannot re enter the one it just completed so the same level
#doesn't start again. the exit door timer will also start which allows for the exits doors to close
#so the physically cannot re enter the level it just completed. in any other case when the player exits
#the map they're out of bounds which is why this variable is set to true
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

#when the player enters the passage between levels denote which one they're in in order to run certain
#events such as the exit doors closing
func _on_passage_way_3_body_entered(_body):
	passage_way = "passage_way_3_entered"

#in case the player leaves too soon, functionality such as the exit doors closing will still occur
#as long as the passage_way variable has anything to do with the particular level the exits doors are
#on in order fully ensure functionality such as this occurs
func _on_passage_way_3_body_exited(_body):
	passage_way = "passage_way_3_exited"

#used for enemies if they go out of bounds, if so, make this apparent so certain functionality can 
#occur such as teleporting them back in in so they can't leave
func _on_level_3_area_entered(area):
	if area.is_in_group("out_of_bounds_checker"):
		area.get_parent().out_of_bounds = false
	else:
		pass

#making sure to turn of the out_of_bounds boolean when an enemy re eneters so they aren't constantly
#being teleported into the centre of the map
func _on_level_3_area_exited(area):
	if area.is_in_group("out_of_bounds_checker"):
		area.get_parent().out_of_bounds = true
	else:
		pass


#checks if the body entered the level region is the player and if so, enable that speicifc level boolean
#which results in functionality exclusive to that level, ensure the player isn't out of bounds and reset
#the player all so that level functionality can occur and the player won't be constantly teleported
#into the centre of the map as a result of being out of bounds as well as making sure the player is
#reset and prepared for the next level 
func _on_level_4_body_entered(body):
	if body.name == "Player":
		main.levels[3] = true
		body.out_of_bounds = false
		main.new_game()
	else:
		pass

#Checks if the body exiting the level region is the player and if the exit is a specific door, stop 
#and that level functionality while disabling the level region and enabling the next level regions so
#the player can enter the next level, but cannot re enter the one it just completed so the same level
#doesn't start again. the exit door timer will also start which allows for the exits doors to close
#so the physically cannot re enter the level it just completed. in any other case when the player exits
#the map they're out of bounds which is why this variable is set to true
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

#when the player enters the passage between levels denote which one they're in in order to run certain
#events such as the exit doors closing
func _on_passage_way_4_body_entered(_body):
	passage_way = "passage_way_4_entered"

#in case the player leaves too soon, functionality such as the exit doors closing will still occur
#as long as the passage_way variable has anything to do with the particular level the exits doors are
#on in order fully ensure functionality such as this occurs
func _on_passage_way_4_body_exited(_body):
	passage_way = "passage_way_4_exited"

#used for enemies if they go out of bounds, if so, make this apparent so certain functionality can 
#occur such as teleporting them back in in so they can't leave
func _on_level_4_area_entered(area):
	if area.is_in_group("out_of_bounds_checker"):
		area.get_parent().out_of_bounds = false
	else:
		pass

#making sure to turn of the out_of_bounds boolean when an enemy re eneters so they aren't constantly
#being teleported into the centre of the map
func _on_level_4_area_exited(area):
	if area.is_in_group("out_of_bounds_checker"):
		area.get_parent().out_of_bounds = true
	else:
		pass


#Level 5
#Checks if the body entered the level region is the player and if so, that level functionality takes place as well as the player isn't out of bounds
func _on_level_5_body_entered(body):
	if body.name == "Player":
		body.out_of_bounds = false
		main.levels[4] = true
		main.new_game()
	else:
		pass

#since it's the final level, if the player leaves the map at all it counts as out of bounds and will teleport them back in
func _on_level_5_body_exited(body):
	if body.name == "Player":
		body.out_of_bounds = true
	else:
		pass

#used for enemies if they go out of bounds, if so, make this apparent so certain functionality can 
#occur such as teleporting them back in in so they can't leave
func _on_level_5_area_entered(area):
	if area.is_in_group("out_of_bounds_checker"):
		area.get_parent().out_of_bounds = false
	else:
		pass

#making sure to turn of the out_of_bounds boolean when an enemy re eneters so they aren't constantly
#being teleported into the centre of the map
func _on_level_5_area_exited(area):
	if area.is_in_group("out_of_bounds_checker"):
		area.get_parent().out_of_bounds = true
	else:
		pass


#Close exit doors based on which level passage way the player has entered so the player cannot re 
#enter the level
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
