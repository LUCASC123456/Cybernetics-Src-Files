extends Node2D

@onready var main = get_node("/root/Main")

signal hit_p

var mafia_enforcer_scene := preload("res://scenes/mafia_enforcer.tscn")
var spawn_points_level_1 := []
var spawn_points_level_2 := []
var spawn_points_level_3 := []
var spawn_points_level_4 := []

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
	#check how many enemies have already been created
	var enemies_level_1 = get_tree().get_nodes_in_group("enemies_level_1")
	var enemies_level_2 = get_tree().get_nodes_in_group("enemies_level_2")
	var enemies_level_3 = get_tree().get_nodes_in_group("enemies_level_3")
	var enemies_level_4 = get_tree().get_nodes_in_group("enemies_level_4")
	
	if enemies_level_1.size() < get_parent().enemy_level_count[0]:
		#pick a random spawnpoint
		var spawn_level_1 = spawn_points_level_1[randi() % spawn_points_level_1.size()]
		#spawn enemy
		var mafia_enforcer_level_1 = mafia_enforcer_scene.instantiate()
		mafia_enforcer_level_1.position = spawn_level_1.position
		mafia_enforcer_level_1.hit_player.connect(hit)
		main.add_child(mafia_enforcer_level_1)
		mafia_enforcer_level_1.add_to_group("enemies_level_1")
		
	if enemies_level_2.size() < get_parent().enemy_level_count[1]:
		#pick a random spawnpoint
		var spawn_level_2 = spawn_points_level_2[randi() % spawn_points_level_2.size()]
		#spawn enemy
		var mafia_enforcer_level_2 = mafia_enforcer_scene.instantiate()
		mafia_enforcer_level_2.position = spawn_level_2.position
		mafia_enforcer_level_2.hit_player.connect(hit)
		main.add_child(mafia_enforcer_level_2)
		mafia_enforcer_level_2.add_to_group("enemies_level_2")
		
	if enemies_level_3.size() < get_parent().enemy_level_count[2]:
		#pick a random spawnpoint
		var spawn_level_3 = spawn_points_level_3[randi() % spawn_points_level_3.size()]
		#spawn enemy
		var mafia_enforcer_level_3 = mafia_enforcer_scene.instantiate()
		mafia_enforcer_level_3.position = spawn_level_3.position
		mafia_enforcer_level_3.hit_player.connect(hit)
		main.add_child(mafia_enforcer_level_3)
		mafia_enforcer_level_3.add_to_group("enemies_level_1")
	
	if enemies_level_4.size() < get_parent().enemy_level_count[3]:
		#pick a random spawnpoint
		var spawn_level_4 = spawn_points_level_4[randi() % spawn_points_level_4.size()]
		#spawn enemy
		var mafia_enforcer_level_4 = mafia_enforcer_scene.instantiate()
		mafia_enforcer_level_4.position = spawn_level_4.position
		mafia_enforcer_level_4.hit_player.connect(hit)
		main.add_child(mafia_enforcer_level_4)
		mafia_enforcer_level_4.add_to_group("enemies_level_4")
	
func hit():
	hit_p.emit()
