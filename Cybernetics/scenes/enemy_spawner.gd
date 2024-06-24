extends Node2D

@onready var main = get_node("/root/Main")

signal hit_p

var mafia_enforcer_scene := preload("res://scenes/mafia_enforcer.tscn")
var spawn_points := []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_children():
		if i is Marker2D:
			spawn_points.append(i)

func _on_timer_timeout():
	#check how many enemies have already been created
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.size() < get_parent().max_enemies:
		#pick a random spawnpoint
		var spawn = spawn_points[randi() % spawn_points.size()]
		#spawn enemy
		var mafia_enforcer = mafia_enforcer_scene.instantiate()
		mafia_enforcer.position = spawn.position
		mafia_enforcer.hit_player.connect(hit)
		main.add_child(mafia_enforcer)
		mafia_enforcer.add_to_group("enemies")
	
func hit():
	hit_p.emit()
