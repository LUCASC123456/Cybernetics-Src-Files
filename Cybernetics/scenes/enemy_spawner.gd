extends Node2D

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")
@onready var world = get_node("/root/Main/World")
@onready var ui = get_node("/root/Main/UI")

var mafia_enforcer_scene := preload("res://scenes/mafia_enforcer.tscn")
var mafia_enforcer_scene_2 := preload("res://scenes/mafia_enforcer_2.tscn")
var mafia_enforcer_scene_3 := preload("res://scenes/mafia_enforcer_3.tscn")
var mafia_enforcer_scene_4 := preload("res://scenes/mafia_enforcer_4.tscn")
var mafia_enforcer_scene_5 := preload("res://scenes/mafia_enforcer_5.tscn")
var mafia_enforcer_scene_6 := preload("res://scenes/mafia_enforcer_6.tscn")
var mafia_enforcer_scene_7 := preload("res://scenes/mafia_enforcer_7.tscn")
var mafia_enforcer_scene_8 := preload("res://scenes/mafia_enforcer_8.tscn")
var mafia_enforcer_scene_9 := preload("res://scenes/mafia_enforcer_9.tscn")
var boss_scene := preload("res://scenes/boss.tscn")

var target_area_node := preload("res://scenes/target_area_node.tscn")

var spawn_points_level_1 := []
var spawn_points_level_2 := []
var spawn_points_level_3 := []
var spawn_points_level_4 := []
var spawn_points_level_5 := []

var enemies_level_1 : Array
var enemies_level_2 : Array
var enemies_level_3 : Array
var enemies_level_4 : Array
var enemies_level_5 : Array

var probability : float

func _ready():
	for i in $Level1.get_children():
		if i is Marker2D:
			spawn_points_level_1.append(i)
			
	for i in $Level2.get_children():
		if i is Marker2D:
			spawn_points_level_2.append(i)
			
	for i in $Level3.get_children():
		if i is Marker2D:
			spawn_points_level_3.append(i)
			
	for i in $Level4.get_children():
		if i is Marker2D:
			spawn_points_level_4.append(i)
	
	for i in $Level5.get_children():
		if i is Marker2D:
			spawn_points_level_5.append(i)

func reset():
	$Timer.stop()
	$Timer2.stop()

func _on_timer_timeout():
	enemies_level_1 = get_tree().get_nodes_in_group("enemies_level_1")
	enemies_level_2 = get_tree().get_nodes_in_group("enemies_level_2")
	enemies_level_3 = get_tree().get_nodes_in_group("enemies_level_3")
	enemies_level_4 = get_tree().get_nodes_in_group("enemies_level_4")
	enemies_level_5 = get_tree().get_nodes_in_group("enemies_level_5")
	
	if main.levels[0]:
		if enemies_level_1.size() < get_parent().enemy_level_count[0]:
			probability = randf()
			
			if probability >= 0.6:
				var spawn_level_1 = spawn_points_level_1[randi() % spawn_points_level_1.size()]
				
				var mafia_enforcer_level_1 = mafia_enforcer_scene.instantiate()
				
				if spawn_level_1.is_in_group("horizontal"):
					mafia_enforcer_level_1.start_dir = "horizontal"
				elif spawn_level_1.is_in_group("vertical"):
					mafia_enforcer_level_1.start_dir= "vertical"
				
				mafia_enforcer_level_1.position = spawn_level_1.position
				main.add_child(mafia_enforcer_level_1)
				mafia_enforcer_level_1.add_to_group("enemies_level_1")
			elif probability < 0.6 and probability >= 0.3:
				var spawn_level_1 = spawn_points_level_1[randi() % spawn_points_level_1.size()]
				
				var mafia_enforcer_level_1 = mafia_enforcer_scene_2.instantiate()
				
				if spawn_level_1.is_in_group("horizontal"):
					mafia_enforcer_level_1.start_dir = "horizontal"
				elif spawn_level_1.is_in_group("vertical"):
					mafia_enforcer_level_1.start_dir= "vertical"
				
				mafia_enforcer_level_1.position = spawn_level_1.position
				main.add_child(mafia_enforcer_level_1)
				mafia_enforcer_level_1.add_to_group("enemies_level_1")
			elif probability < 0.3 and probability >= 0.1:
				var spawn_level_1 = spawn_points_level_1[randi() % spawn_points_level_1.size()]
				
				var mafia_enforcer_level_1 = mafia_enforcer_scene_3.instantiate()
				
				if spawn_level_1.is_in_group("horizontal"):
					mafia_enforcer_level_1.start_dir = "horizontal"
				elif spawn_level_1.is_in_group("vertical"):
					mafia_enforcer_level_1.start_dir= "vertical"
				
				mafia_enforcer_level_1.position = spawn_level_1.position
				main.add_child(mafia_enforcer_level_1)
				mafia_enforcer_level_1.add_to_group("enemies_level_1")
			elif probability < 0.1:
				var spawn_level_1 = spawn_points_level_1[randi() % spawn_points_level_1.size()]
				
				var mafia_enforcer_level_1 = mafia_enforcer_scene_4.instantiate()
				
				if spawn_level_1.is_in_group("horizontal"):
					mafia_enforcer_level_1.start_dir = "horizontal"
				elif spawn_level_1.is_in_group("vertical"):
					mafia_enforcer_level_1.start_dir= "vertical"
				
				mafia_enforcer_level_1.position = spawn_level_1.position
				main.add_child(mafia_enforcer_level_1)
				mafia_enforcer_level_1.add_to_group("enemies_level_1")
		else:
			$Timer.stop()
			$Timer2.start()
	
	elif main.levels[1]:
		if enemies_level_2.size() < get_parent().enemy_level_count[1]:
			probability = randf()
			if probability >= 0.7:
				var spawn_level_2 = spawn_points_level_2[randi() % spawn_points_level_2.size()]
				
				var mafia_enforcer_level_2 = mafia_enforcer_scene.instantiate()
				
				if spawn_level_2.is_in_group("horizontal"):
					mafia_enforcer_level_2.start_dir = "horizontal"
				elif spawn_level_2.is_in_group("vertical"):
					mafia_enforcer_level_2.start_dir= "vertical"
				
			elif probability < 0.7 and probability >= 0.5:
				var spawn_level_2 = spawn_points_level_2[randi() % spawn_points_level_2.size()]
				
				var mafia_enforcer_level_2 = mafia_enforcer_scene_2.instantiate()
				
				if spawn_level_2.is_in_group("horizontal"):
					mafia_enforcer_level_2.start_dir = "horizontal"
				elif spawn_level_2.is_in_group("vertical"):
					mafia_enforcer_level_2.start_dir= "vertical"
					
				mafia_enforcer_level_2.position = spawn_level_2.position
				main.add_child(mafia_enforcer_level_2)
				mafia_enforcer_level_2.add_to_group("enemies_level_2")
			elif probability < 0.5 and probability >= 0.4:
				var spawn_level_2 = spawn_points_level_2[randi() % spawn_points_level_2.size()]
				
				var mafia_enforcer_level_2 = mafia_enforcer_scene_3.instantiate()
				
				if spawn_level_2.is_in_group("horizontal"):
					mafia_enforcer_level_2.start_dir = "horizontal"
				elif spawn_level_2.is_in_group("vertical"):
					mafia_enforcer_level_2.start_dir= "vertical"
					
				mafia_enforcer_level_2.position = spawn_level_2.position
				main.add_child(mafia_enforcer_level_2)
				mafia_enforcer_level_2.add_to_group("enemies_level_2")
			elif probability < 0.4 and probability >= 0.2:
				var spawn_level_2 = spawn_points_level_2[randi() % spawn_points_level_2.size()]
				
				var mafia_enforcer_level_2 = mafia_enforcer_scene_4.instantiate()
				
				if spawn_level_2.is_in_group("horizontal"):
					mafia_enforcer_level_2.start_dir = "horizontal"
				elif spawn_level_2.is_in_group("vertical"):
					mafia_enforcer_level_2.start_dir= "vertical"
					
				mafia_enforcer_level_2.position = spawn_level_2.position
				main.add_child(mafia_enforcer_level_2)
				mafia_enforcer_level_2.add_to_group("enemies_level_2")
			elif probability < 0.2 and probability >= 0.1:
				var spawn_level_2 = spawn_points_level_2[randi() % spawn_points_level_2.size()]
				
				var mafia_enforcer_level_2 = mafia_enforcer_scene_8.instantiate()
				
				if spawn_level_2.is_in_group("horizontal"):
					mafia_enforcer_level_2.start_dir = "horizontal"
				elif spawn_level_2.is_in_group("vertical"):
					mafia_enforcer_level_2.start_dir= "vertical"
					
				mafia_enforcer_level_2.position = spawn_level_2.position
				main.add_child(mafia_enforcer_level_2)
				mafia_enforcer_level_2.add_to_group("enemies_level_2")
			elif probability < 0.1:
				var spawn_level_2 = spawn_points_level_2[randi() % spawn_points_level_2.size()]
				
				var mafia_enforcer_level_2 = mafia_enforcer_scene_9.instantiate()
				
				if spawn_level_2.is_in_group("horizontal"):
					mafia_enforcer_level_2.start_dir = "horizontal"
				elif spawn_level_2.is_in_group("vertical"):
					mafia_enforcer_level_2.start_dir= "vertical"
					
				mafia_enforcer_level_2.position = spawn_level_2.position
				main.add_child(mafia_enforcer_level_2)
				mafia_enforcer_level_2.add_to_group("enemies_level_2")
		else:
			$Timer.stop()
			$Timer2.start()
			
	elif main.levels[2]:
		if enemies_level_3.size() < get_parent().enemy_level_count[2]:
			probability = randf()
			
			if probability >= 0.8:
				var spawn_level_3 = spawn_points_level_3[randi() % spawn_points_level_3.size()]
				
				var mafia_enforcer_level_3 = mafia_enforcer_scene.instantiate()
				
				if spawn_level_3.is_in_group("horizontal"):
					mafia_enforcer_level_3.start_dir = "horizontal"
				elif spawn_level_3.is_in_group("vertical"):
					mafia_enforcer_level_3.start_dir = "vertical"
					
				mafia_enforcer_level_3.position = spawn_level_3.position
				main.add_child(mafia_enforcer_level_3)
				mafia_enforcer_level_3.add_to_group("enemies_level_3")
			elif probability < 0.8 and probability >= 0.7:
				var spawn_level_3 = spawn_points_level_3[randi() % spawn_points_level_3.size()]
				
				var mafia_enforcer_level_3 = mafia_enforcer_scene_2.instantiate()
				
				if spawn_level_3.is_in_group("horizontal"):
					mafia_enforcer_level_3.start_dir = "horizontal"
				elif spawn_level_3.is_in_group("vertical"):
					mafia_enforcer_level_3.start_dir = "vertical"
					
				mafia_enforcer_level_3.position = spawn_level_3.position
				main.add_child(mafia_enforcer_level_3)
				mafia_enforcer_level_3.add_to_group("enemies_level_3")
			elif probability > 0.7 and probability >= 0.6:
				var spawn_level_3 = spawn_points_level_3[randi() % spawn_points_level_3.size()]
				
				var mafia_enforcer_level_3 = mafia_enforcer_scene_3.instantiate()
				
				if spawn_level_3.is_in_group("horizontal"):
					mafia_enforcer_level_3.start_dir = "horizontal"
				elif spawn_level_3.is_in_group("vertical"):
					mafia_enforcer_level_3.start_dir = "vertical"
					
				mafia_enforcer_level_3.position = spawn_level_3.position
				main.add_child(mafia_enforcer_level_3)
				mafia_enforcer_level_3.add_to_group("enemies_level_3")
			elif probability < 0.6 and probability >= 0.5:
				var spawn_level_3 = spawn_points_level_3[randi() % spawn_points_level_3.size()]
				
				var mafia_enforcer_level_3 = mafia_enforcer_scene_4.instantiate()
				
				if spawn_level_3.is_in_group("horizontal"):
					mafia_enforcer_level_3.start_dir = "horizontal"
				elif spawn_level_3.is_in_group("vertical"):
					mafia_enforcer_level_3.start_dir = "vertical"
					
				mafia_enforcer_level_3.position = spawn_level_3.position
				main.add_child(mafia_enforcer_level_3)
				mafia_enforcer_level_3.add_to_group("enemies_level_3")
			elif probability < 0.5 and probability >= 0.4:
				var spawn_level_3 = spawn_points_level_3[randi() % spawn_points_level_3.size()]
				
				var mafia_enforcer_level_3 = mafia_enforcer_scene_8.instantiate()
				
				if spawn_level_3.is_in_group("horizontal"):
					mafia_enforcer_level_3.start_dir = "horizontal"
				elif spawn_level_3.is_in_group("vertical"):
					mafia_enforcer_level_3.start_dir = "vertical"
					
				mafia_enforcer_level_3.position = spawn_level_3.position
				main.add_child(mafia_enforcer_level_3)
				mafia_enforcer_level_3.add_to_group("enemies_level_3")
			elif probability < 0.4 and probability >= 0.3:
				var spawn_level_3 = spawn_points_level_3[randi() % spawn_points_level_3.size()]
				
				var mafia_enforcer_level_3 = mafia_enforcer_scene_9.instantiate()
				
				if spawn_level_3.is_in_group("horizontal"):
					mafia_enforcer_level_3.start_dir = "horizontal"
				elif spawn_level_3.is_in_group("vertical"):
					mafia_enforcer_level_3.start_dir = "vertical"
				
				mafia_enforcer_level_3.position = spawn_level_3.position
				main.add_child(mafia_enforcer_level_3)
				mafia_enforcer_level_3.add_to_group("enemies_level_3")
			elif probability < 0.3 and probability >= 0.1:
				var spawn_level_3 = spawn_points_level_3[randi() % spawn_points_level_3.size()]
				
				var mafia_enforcer_level_3 = mafia_enforcer_scene_6.instantiate()
				
				if spawn_level_3.is_in_group("horizontal"):
					mafia_enforcer_level_3.start_dir = "horizontal"
				elif spawn_level_3.is_in_group("vertical"):
					mafia_enforcer_level_3.start_dir = "vertical"
				
				mafia_enforcer_level_3.position = spawn_level_3.position
				main.add_child(mafia_enforcer_level_3)
				mafia_enforcer_level_3.add_to_group("enemies_level_3")
			elif probability < 0.1:
				var spawn_level_3 = spawn_points_level_3[randi() % spawn_points_level_3.size()]
				
				var mafia_enforcer_level_3 = mafia_enforcer_scene_7.instantiate()
				
				if spawn_level_3.is_in_group("horizontal"):
					mafia_enforcer_level_3.start_dir = "horizontal"
				elif spawn_level_3.is_in_group("vertical"):
					mafia_enforcer_level_3.start_dir = "vertical"
					
				mafia_enforcer_level_3.position = spawn_level_3.position
				main.add_child(mafia_enforcer_level_3)
				mafia_enforcer_level_3.add_to_group("enemies_level_3")
		else:
			$Timer.stop()
			$Timer2.start()
			
	elif main.levels[3]:
		if enemies_level_4.size() < get_parent().enemy_level_count[3]:
			probability = randf()
			
			if probability >= 0.8:
				var spawn_level_4 = spawn_points_level_4[randi() % spawn_points_level_4.size()]
				
				var mafia_enforcer_level_4 = mafia_enforcer_scene.instantiate()
				
				if spawn_level_4.is_in_group("horizontal"):
					mafia_enforcer_level_4.start_dir = "horizontal"
				elif spawn_level_4.is_in_group("vertical"):
					mafia_enforcer_level_4.start_dir= "vertical"
				
				mafia_enforcer_level_4.position = spawn_level_4.position
				main.add_child(mafia_enforcer_level_4)
				mafia_enforcer_level_4.add_to_group("enemies_level_4")
			elif probability < 0.8 and probability >= 0.7:
				var spawn_level_4 = spawn_points_level_4[randi() % spawn_points_level_4.size()]
				
				var mafia_enforcer_level_4 = mafia_enforcer_scene_2.instantiate()
				
				if spawn_level_4.is_in_group("horizontal"):
					mafia_enforcer_level_4.start_dir = "horizontal"
				elif spawn_level_4.is_in_group("vertical"):
					mafia_enforcer_level_4.start_dir= "vertical"
				
				mafia_enforcer_level_4.position = spawn_level_4.position
				main.add_child(mafia_enforcer_level_4)
				mafia_enforcer_level_4.add_to_group("enemies_level_4")
			elif probability < 0.7 and probability >= 0.6:
				var spawn_level_4 = spawn_points_level_4[randi() % spawn_points_level_4.size()]
				
				var mafia_enforcer_level_4 = mafia_enforcer_scene_3.instantiate()
				
				if spawn_level_4.is_in_group("horizontal"):
					mafia_enforcer_level_4.start_dir = "horizontal"
				elif spawn_level_4.is_in_group("vertical"):
					mafia_enforcer_level_4.start_dir= "vertical"
				
				mafia_enforcer_level_4.position = spawn_level_4.position
				main.add_child(mafia_enforcer_level_4)
				mafia_enforcer_level_4.add_to_group("enemies_level_4")
			elif probability < 0.6 and probability >= 0.5:
				var spawn_level_4 = spawn_points_level_4[randi() % spawn_points_level_4.size()]
				
				var mafia_enforcer_level_4 = mafia_enforcer_scene_4.instantiate()
				
				if spawn_level_4.is_in_group("horizontal"):
					mafia_enforcer_level_4.start_dir = "horizontal"
				elif spawn_level_4.is_in_group("vertical"):
					mafia_enforcer_level_4.start_dir= "vertical"
				
				mafia_enforcer_level_4.position = spawn_level_4.position
				main.add_child(mafia_enforcer_level_4)
				mafia_enforcer_level_4.add_to_group("enemies_level_4")
			elif probability < 0.5 and probability >= 0.4:
				var spawn_level_4 = spawn_points_level_4[randi() % spawn_points_level_4.size()]
				
				var mafia_enforcer_level_4 = mafia_enforcer_scene_8.instantiate()
				
				if spawn_level_4.is_in_group("horizontal"):
					mafia_enforcer_level_4.start_dir = "horizontal"
				elif spawn_level_4.is_in_group("vertical"):
					mafia_enforcer_level_4.start_dir= "vertical"
				
				mafia_enforcer_level_4.position = spawn_level_4.position
				main.add_child(mafia_enforcer_level_4)
				mafia_enforcer_level_4.add_to_group("enemies_level_4")
			elif probability < 0.4 and probability >= 0.3:
				var spawn_level_4 = spawn_points_level_4[randi() % spawn_points_level_4.size()]
				
				var mafia_enforcer_level_4 = mafia_enforcer_scene_9.instantiate()
				
				if spawn_level_4.is_in_group("horizontal"):
					mafia_enforcer_level_4.start_dir = "horizontal"
				elif spawn_level_4.is_in_group("vertical"):
					mafia_enforcer_level_4.start_dir= "vertical"
				
				mafia_enforcer_level_4.position = spawn_level_4.position
				main.add_child(mafia_enforcer_level_4)
				mafia_enforcer_level_4.add_to_group("enemies_level_4")
			elif probability < 0.3 and probability >= 0.2:
				var spawn_level_4 = spawn_points_level_4[randi() % spawn_points_level_4.size()]
				
				var mafia_enforcer_level_4 = mafia_enforcer_scene_6.instantiate()
				
				if spawn_level_4.is_in_group("horizontal"):
					mafia_enforcer_level_4.start_dir = "horizontal"
				elif spawn_level_4.is_in_group("vertical"):
					mafia_enforcer_level_4.start_dir= "vertical"
				
				mafia_enforcer_level_4.position = spawn_level_4.position
				main.add_child(mafia_enforcer_level_4)
				mafia_enforcer_level_4.add_to_group("enemies_level_4")
			elif probability < 0.2 and probability >= 0.1:
				var spawn_level_4 = spawn_points_level_4[randi() % spawn_points_level_4.size()]
				
				var mafia_enforcer_level_4 = mafia_enforcer_scene_7.instantiate()
				
				if spawn_level_4.is_in_group("horizontal"):
					mafia_enforcer_level_4.start_dir = "horizontal"
				elif spawn_level_4.is_in_group("vertical"):
					mafia_enforcer_level_4.start_dir= "vertical"
				
				mafia_enforcer_level_4.position = spawn_level_4.position
				main.add_child(mafia_enforcer_level_4)
				mafia_enforcer_level_4.add_to_group("enemies_level_4")
			elif probability < 0.1:
				var spawn_level_4 = spawn_points_level_4[randi() % spawn_points_level_4.size()]
				
				var mafia_enforcer_level_4 = mafia_enforcer_scene_5.instantiate()
				
				if spawn_level_4.is_in_group("horizontal"):
					mafia_enforcer_level_4.start_dir = "horizontal"
				elif spawn_level_4.is_in_group("vertical"):
					mafia_enforcer_level_4.start_dir= "vertical"
				
				mafia_enforcer_level_4.position = spawn_level_4.position
				main.add_child(mafia_enforcer_level_4)
				mafia_enforcer_level_4.add_to_group("enemies_level_4")
				
				var target_area = target_area_node.instantiate()
				main.add_child(target_area)
		else:
			$Timer.stop()
			$Timer2.start()
	elif main.levels[4]:
		if enemies_level_5.size() < get_parent().enemy_level_count[4]:
			var spawn_level_5 = spawn_points_level_5[0]
				
			var boss = boss_scene.instantiate()
			
			boss.position = spawn_level_5.position
			main.add_child(boss)
			boss.add_to_group("enemies_level_5")
			
			var target_area = target_area_node.instantiate()
			main.add_child(target_area)
		else:
			$Timer.stop()
			$Timer2.start()
	else:
		$Timer.stop()
		$Timer2.start()

func _on_timer_2_timeout():
	if main.levels[0] or world.passage_way == "passage_way_1_entered" or world.passage_way == "passage_way_1_exited":
		for tile_coord_array in main.enemy_door_coordinates["Level1"]:
			for tile_coord in tile_coord_array:
				if tile_coord == Vector2i(6,0) or tile_coord == Vector2i(6,15):
					world.set_cell(1, tile_coord, 7, Vector2i(0,17), 0)
				elif tile_coord == Vector2i(9,0) or tile_coord == Vector2i(9,15):
					world.set_cell(1, tile_coord, 7, Vector2i(0,18), 0)
				else:
					world.set_cell(1, tile_coord, 7, Vector2i(0,19), 0)
	elif main.levels[1] or world.passage_way == "passage_way_2_entered" or world.passage_way == "passage_way_2_exited":
		for tile_coord_array in main.enemy_door_coordinates["Level2"]:
			for tile_coord in tile_coord_array:
				if tile_coord == Vector2i(32,0) or tile_coord == Vector2i(44,0) or tile_coord == Vector2i(32,15) or tile_coord == Vector2i(44,15):
					world.set_cell(1, tile_coord, 7, Vector2i(0,17), 0)
				elif tile_coord == Vector2i(35,0) or tile_coord == Vector2i(47,0) or tile_coord == Vector2i(35,15) or tile_coord == Vector2i(47,15):
					world.set_cell(1, tile_coord, 7, Vector2i(0,18), 0)
				else:
					world.set_cell(1, tile_coord, 7, Vector2i(0,19), 0)
		
	elif main.levels[2] or world.passage_way == "passage_way_3_entered" or world.passage_way == "passage_way_3_exited":
		for tile_coord_array in main.enemy_door_coordinates["Level3"]:
			for tile_coord in tile_coord_array:
				if tile_coord == Vector2i(35,31) or tile_coord == Vector2i(98,31):
					world.set_cell(1, tile_coord, 7, Vector2i(0,9), 0)
				else:
					world.set_cell(1, tile_coord, 7, Vector2i(0,16), 0)
				
	elif main.levels[3] or world.passage_way == "passage_way_4_entered" or world.passage_way == "passage_way_4_exited":
		for tile_coord_array in main.enemy_door_coordinates["Level4"]:
			for tile_coord in tile_coord_array:
				if tile_coord_array == main.enemy_door_coordinates["Level4"][1]:
					if tile_coord == Vector2i(144, 19):
						world.set_cell(1, tile_coord, 7, Vector2i(0,17), 0)
					elif tile_coord == Vector2i(152, 29):
						world.set_cell(1, tile_coord, 7, Vector2i(0,18), 0)
					else:
						world.set_cell(1, tile_coord, 7, Vector2i(0,19), 0)
				else:
					if tile_coord == Vector2i(122, 29):
						world.set_cell(1, tile_coord, 7, Vector2i(0,11), 0)
					elif tile_coord == Vector2i(174, 29):
						world.set_cell(1, tile_coord, 7, Vector2i(0,10), 0)
					else:
						world.set_cell(1, tile_coord, 7, Vector2i(0,16), 0)
