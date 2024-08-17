extends Node2D

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")

signal hit_p

var mafia_enforcer_scene := preload("res://scenes/mafia_enforcer.tscn")
var spawn_points_level_1 := []
var spawn_points_level_2 := []
var spawn_points_level_3 := []
var spawn_points_level_4 := []

var enemies_level_1 : Array
var enemies_level_2 : Array
var enemies_level_3 : Array
var enemies_level_4 : Array

# Called when the node enters the scene tree for the first time.
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

func _on_timer_timeout():
	var enemies_level_1 = get_tree().get_nodes_in_group("enemies_level_1")
	var enemies_level_2 = get_tree().get_nodes_in_group("enemies_level_2")
	var enemies_level_3 = get_tree().get_nodes_in_group("enemies_level_3")
	var enemies_level_4 = get_tree().get_nodes_in_group("enemies_level_4")
	
	if main.levels[0] == true:
		if enemies_level_1.size() < get_parent().enemy_level_count[0]:
			var spawn_level_1 = spawn_points_level_1[randi() % spawn_points_level_1.size()]
			
			var mafia_enforcer_level_1 = mafia_enforcer_scene.instantiate()
			mafia_enforcer_level_1.position = spawn_level_1.position
			mafia_enforcer_level_1.hit_player.connect(hit)
			main.add_child(mafia_enforcer_level_1)
			mafia_enforcer_level_1.add_to_group("enemies_level_1")
		
		else:
			$Timer2.start()
	
	elif main.levels[1] == true:
		if enemies_level_2.size() < get_parent().enemy_level_count[1]:
			var spawn_level_2 = spawn_points_level_2[randi() % spawn_points_level_2.size()]
			
			var mafia_enforcer_level_2 = mafia_enforcer_scene.instantiate()
			mafia_enforcer_level_2.position = spawn_level_2.position
			mafia_enforcer_level_2.hit_player.connect(hit)
			main.add_child(mafia_enforcer_level_2)
			mafia_enforcer_level_2.add_to_group("enemies_level_2")
	
		else:
			$Timer2.start()
			
	elif main.levels[2] == true:
		if enemies_level_3.size() < get_parent().enemy_level_count[2]:
			var spawn_level_3 = spawn_points_level_3[randi() % spawn_points_level_3.size()]
			
			var mafia_enforcer_level_3 = mafia_enforcer_scene.instantiate()
			mafia_enforcer_level_3.position = spawn_level_3.position
			mafia_enforcer_level_3.hit_player.connect(hit)
			main.add_child(mafia_enforcer_level_3)
			mafia_enforcer_level_3.add_to_group("enemies_level_3")
			
		else:
			$Timer2.start()
			
	elif main.levels[3] == true:
		if enemies_level_4.size() < get_parent().enemy_level_count[3]:
			var spawn_level_4 = spawn_points_level_4[randi() % spawn_points_level_4.size()]
			
			var mafia_enforcer_level_4 = mafia_enforcer_scene.instantiate()
			mafia_enforcer_level_4.position = spawn_level_4.position
			mafia_enforcer_level_4.hit_player.connect(hit)
			main.add_child(mafia_enforcer_level_4)
			mafia_enforcer_level_4.add_to_group("enemies_level_4")
		else:
			$Timer2.start()
			
func hit():
	hit_p.emit()


func _on_timer_2_timeout():
	if main.levels[0] == true:
		for i in range(0, len(main.x_coordinates_level_1)-4):
			main.get_child(0).set_cell(1, Vector2i(main.x_coordinates_level_1[i], main.y_coordinates_level_1[i]), 0, Vector2i(1,1), 0)
		for i in enemies_level_1:
			if i.position.y < 73:
				i.position.x = randi_range(313, 455)
				i.position.y = 123
			elif i.position.y > 695:
				i.position.x = randi_range(313, 355)
				i.position.y = 645
			
			if player.position.y < 73:
				player.position.x = randi_range(313, 455)
				player.position.y = 123
			elif player.position.y > 695:
				player.position.x = randi_range(313, 355)
				player.position.y = 645
	elif main.levels[1] == true:
		for i in range(4, len(main.x_coordinates_level_2)-4):
			main.get_child(0).set_cell(1, Vector2i(main.x_coordinates_level_2[i], main.y_coordinates_level_2[i]), 0, Vector2i(1,1), 0)
		for i in enemies_level_2:
			if i.position.y < 73:
				if i.position.x > 1561 and i.position.x < 1703:
					i.position.x = randi_range(1561, 1703)
					i.position.y = 123
				elif i.position.x > 2137 and i.position.x < 2279:
					i.position.x = randi_range(2137, 2279)
					i.position.y = 123
			elif i.position.y > 695:
				if i.position.x > 1561 and i.position.x < 1703:
					i.position.x = randi_range(1561, 1703)
					i.position.y = 645
				elif i.position.x > 2137 and i.position.x < 2279:
					i.position.x = randi_range(2137, 2279)
					i.position.y = 645
				
		if player.position.y < 73:
			if player.position.x > 1561 and player.position.x < 1703:
				player.position.x = randi_range(1561, 1703)
				player.position.y = 123
			elif player.position.x > 2137 and player.position.x < 2279:
				player.position.x = randi_range(2137, 2279)
				player.position.y = 123
		elif player.position.y > 695:
			if player.position.x > 1561 and player.position.x < 1703:
				player.position.x = randi_range(1561, 1703)
				player.position.y = 645
			elif player.position.x > 2137 and player.position.x < 2279:
				player.position.x = randi_range(2137, 2279)
				player.position.y = 645
	elif main.levels[2] == true:
		for i in range(4, len(main.x_coordinates_level_3)-4):
			main.get_child(0).set_cell(1, Vector2i(main.x_coordinates_level_3[i], main.y_coordinates_level_3[i]), 0, Vector2i(1,1), 0)
		for i in enemies_level_3:
			if i.position.x < 1753:
				i.position.x = 1803
				i.position.y = randi_range(1561, 1703)
			elif i.position.x > 4679:
				i.position.x = 4629
				i.position.y = randi_range(1561, 1703)
					
		if player.position.x < 1753:
			player.position.x = 1803
			player.position.y = randi_range(1561, 1703)
		elif player.position.x > 4679:
			player.position.x = 4629
			player.position.y = randi_range(1561, 1703)
	elif main.levels[3] == true:
		for i in range(4, len(main.x_coordinates_level_4)-4):
			main.get_child(0).set_cell(1, Vector2i(main.x_coordinates_level_4[i], main.y_coordinates_level_4[i]), 0, Vector2i(1,1), 0)
		for i in enemies_level_4:
			if i.position.x < 5929:
				i.position.x = 5979
				i.position.y = randi_range(1465, 1799)
			elif i.position.x > 8327:
				i.position.x = 8277
				i.position.y = randi_range(1465, 1799)
			elif i.position.y < 985:
				i.position.x = randi_range(6937, 7319)
				i.position.y = 935
			
		if player.position.x < 5929:
			player.position.x = 5979
			player.position.y = randi_range(1465, 1799)
		elif player.position.x > 8327:
			player.position.x = 8277
			player.position.y = randi_range(1465, 1799)
		elif player.position.y < 985:
			player.position.x = randi_range(6937, 7319)
			player.position.y = 935
