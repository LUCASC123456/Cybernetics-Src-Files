extends Node2D

signal enemy_killed

var enemies_left : int
var credits_earned : int
var enemies_killed : int
var damage_inflicted : int
var damage_taken : int
var time_taken : int
var bullets_fired : int
var levels_completed : int
var target_area_nodes : Array
var mafia_enforcer_5s : Array
var boss : CharacterBody2D

var enemy_level_count = [20, 30, 40, 50, 1]
var levels = [true, false, false, false, false]

var player_door_coordinates = {
	"Level1" : [Vector2i(15,6), Vector2i(15,7), Vector2i(15,8), Vector2i(15,9)],
	"Level2" : [[Vector2i(24,6), Vector2i(24,7), Vector2i(24,8), Vector2i(24,9)], [Vector2i(55,6), Vector2i(55,7), Vector2i(55,8), Vector2i(55,9)]],
	"Level3" : [[Vector2i(65,19), Vector2i(66,19), Vector2i(67,19), Vector2i(68,19)], [Vector2i(65,48), Vector2i(66,48), Vector2i(67,48), Vector2i(68,48)]],
	"Level4" : [[Vector2i(127,48), Vector2i(128,48), Vector2i(129,48), Vector2i(130,48)], [Vector2i(167,48), Vector2i(168,48), Vector2i(169,48), Vector2i(170,48)]],
	"Level5" : [Vector2i(167, 63), Vector2i(168, 63), Vector2i(169, 63), Vector2i(170, 63)]
}

var enemy_door_coordinates = {
	"Level1" : [Vector2i(6,0), Vector2i(7,0), Vector2i(8,0), Vector2i(9,0), Vector2i(6,15), Vector2i(7,15), Vector2i(8,15), Vector2i(9,15)],
	"Level2" : [Vector2i(32,0), Vector2i(33,0), Vector2i(34,0), Vector2i(35,0), Vector2i(44,0), Vector2i(45,0), Vector2i(46,0), Vector2i(47,0), Vector2i(32,15), Vector2i(33,15), Vector2i(34,15), Vector2i(35,15), Vector2i(44,15), Vector2i(45,15), Vector2i(46,15), Vector2i(47,15)],
	"Level3" : [Vector2i(35,32), Vector2i(35,33), Vector2i(35,34), Vector2i(35,35), Vector2i(98,32), Vector2i(98,33), Vector2i(98,34), Vector2i(98,35)],
	"Level4" : [Vector2i(122,30), Vector2i(122,31), Vector2i(122,32), Vector2i(122,33), Vector2i(122,34), Vector2i(122,35), Vector2i(122,36), Vector2i(122,37), Vector2i(144,19), Vector2i(145,19), Vector2i(146,19), Vector2i(147,19), Vector2i(148,19), Vector2i(149,19), Vector2i(150,19), Vector2i(151,19), Vector2i(152,19), Vector2i(174,30), Vector2i(174,31), Vector2i(174,32), Vector2i(174,33), Vector2i(174,34), Vector2i(174,35), Vector2i(174,36), Vector2i(174,37)],
	"Level5" : []
}

func _on_tree_entered():
	$MainMenu.load_data()

func _ready():
	get_tree().paused = true
	$RestartTimer.paused = false
	$RestartTimer.stop()
	$CreditTimer.stop()
	$EnemySpawner.reset()
	credits_earned = 0
	enemies_killed = 0
	damage_inflicted = 0
	damage_taken = 0
	time_taken = 0
	bullets_fired = 0
	levels_completed = 0
	
	get_tree().call_group("enemies", "queue_free")
	get_tree().call_group("minions", "queue_free")
	get_tree().call_group("target_area_nodes", "queue_free")
	get_tree().call_group("bullets", "queue_free")
	get_tree().call_group("items", "queue_free")
	
	for i in $World.get_children():
		if i.is_in_group("levels"):
			if i.name == "Level1":
				for k in i.get_children():
					k.set_deferred("disabled", false)
			else:
				for k in i.get_children():
					k.set_deferred("disabled", true)
		else:
			pass
				
	for i in range(0, len(levels)):
		if i == 0:
			levels[i] = true
		else:
			levels[i] = false
	
	for i in player_door_coordinates["Level1"]:
		$World.set_cell(1, i, 0, Vector2i(0,0), 0)
	
	for i in enemy_door_coordinates["Level1"]:
		$World.set_cell(1, i, 0, Vector2i(1,1), 0)
			
	for i in enemy_door_coordinates["Level2"]:
		$World.set_cell(1, i, 0, Vector2i(1,1), 0)
		
	for i in player_door_coordinates["Level2"][1]:
		$World.set_cell(1, i, 0, Vector2i(0,0), 0)
		
	for i in enemy_door_coordinates["Level3"]:
		$World.set_cell(1, i, 0, Vector2i(1,1), 0)
		
	for i in player_door_coordinates["Level3"][1]:
		$World.set_cell(1, i, 0, Vector2i(0,0), 0)
		
	for i in enemy_door_coordinates["Level4"]:
		$World.set_cell(1, i, 0, Vector2i(1,1), 0)
			
	for i in player_door_coordinates["Level4"][1]:
		$World.set_cell(1, i, 0, Vector2i(0,0), 0)
		
	for i in get_children():
		if i is CanvasLayer:
			if i.name == "MainMenu":
				i.show()
			else:
				i.hide()
		else:
			pass

func new_game():
	if levels[0]:
		$Player._ready()
		$MainMenu.hide()
		enemies_left = enemy_level_count[0]
	elif levels[1]:
		$Player.reset()
		enemies_left = enemy_level_count[1]
		get_tree().call_group("enemies_level_1", "queue_free")
		get_tree().call_group("target_area_nodes", "queue_free")
		get_tree().call_group("minions", "queue_free")
		get_tree().call_group("bullets", "queue_free")
		get_tree().call_group("items", "queue_free")
		
	elif levels[2]:
		$Player.reset()
		enemies_left = enemy_level_count[2]
		get_tree().call_group("enemies_level_2", "queue_free")
		get_tree().call_group("target_area_nodes", "queue_free")
		get_tree().call_group("minions", "queue_free")
		get_tree().call_group("bullets", "queue_free")
		get_tree().call_group("items", "queue_free")
		
	elif levels[3]:
		enemies_left = enemy_level_count[3]
		$Player.reset()
		get_tree().call_group("enemies_level_3", "queue_free")
		get_tree().call_group("target_area_nodes", "queue_free")
		get_tree().call_group("minions", "queue_free")
		get_tree().call_group("bullets", "queue_free")
		get_tree().call_group("items", "queue_free")
		
	elif levels[4]:
		enemies_left = enemy_level_count[4]
		$Player.reset()
		get_tree().call_group("enemies_level_4", "queue_free")
		get_tree().call_group("target_area_nodes", "queue_free")
		get_tree().call_group("minions", "queue_free")
		get_tree().call_group("bullets", "queue_free")
		get_tree().call_group("items", "queue_free")
	else:
		pass
	
	$RestartTimer.start()

func _on_restart_timer_timeout():
	if levels[0]:
		get_tree().paused = false
		$UI.show()
		for i in enemy_door_coordinates["Level1"]:
			$World.set_cell(1, i, 0, Vector2i(1,1), -1)
	elif levels[1]:
		for i in enemy_door_coordinates["Level2"]:
			$World.set_cell(1, i, 0, Vector2i(1,1), -1)
		for i in player_door_coordinates["Level2"][0]:
			$World.set_cell(1, i, 0, Vector2i(0,0), 0)
	elif levels[2]:
		for i in enemy_door_coordinates["Level3"]:
			$World.set_cell(1, i, 0, Vector2i(1,1), -1)
		for i in player_door_coordinates["Level3"][0]:
			$World.set_cell(1, i, 0, Vector2i(0,0), 0)
	elif levels[3]:
		for i in enemy_door_coordinates["Level4"]:
			$World.set_cell(1, i, 0, Vector2i(1,1), -1)
		for i in player_door_coordinates["Level4"][0]:
			$World.set_cell(1, i, 0, Vector2i(0,0), 0)
	elif levels[4]:
		for i in player_door_coordinates["Level5"]:
			$World.set_cell(1, i, 0, Vector2i(0,0), 0)
	else:
		pass
	
	$CreditTimer.start()
	$EnemySpawner.get_node("Timer").start()

func _physics_process(_delta):
	target_area_nodes = get_tree().get_nodes_in_group("target_area_nodes")
	mafia_enforcer_5s = get_tree().get_nodes_in_group("mafia_enforcer_5")
	boss = get_tree().get_first_node_in_group("boss")

	if mafia_enforcer_5s.size() > 0:
		for i in range(0, len(mafia_enforcer_5s)):
			if mafia_enforcer_5s[i].alive:
				target_area_nodes[i].draw_target_area(mafia_enforcer_5s[i].global_position)
			else:
				pass
	elif boss:
		target_area_nodes[0].draw_target_area(boss.global_position)
	else:
		pass

func _on_credit_timer_timeout():
	time_taken += 1
	if credits_earned > 0:
		credits_earned -= 2
		if credits_earned <= 0:
			credits_earned = 0
		else:
			pass
	else:
		pass

func _on_enemy_killed():
	enemies_left -= 1
	enemies_killed += 1
	if enemies_left <= 0:
		levels_completed += 1
		$CreditTimer.stop()
		
		if levels[0]:
			for i in player_door_coordinates["Level1"]:
				$World.set_cell(1, i, 0, Vector2i(0,0), -1)
			for i in player_door_coordinates["Level2"][0]:
				$World.set_cell(1, i, 0, Vector2i(0,0), -1)
		elif levels[1]:
			for i in player_door_coordinates["Level2"][1]:
				$World.set_cell(1, i, 0, Vector2i(0,0), -1)
			for i in player_door_coordinates["Level3"][0]:
				$World.set_cell(1, i, 0, Vector2i(0,0), -1)
		elif levels[2]: 
			for i in player_door_coordinates["Level3"][1]:
				$World.set_cell(1, i, 0, Vector2i(0,0), -1)
			for i in player_door_coordinates["Level4"][0]:
				$World.set_cell(1, i, 0, Vector2i(0,0), -1)
		elif levels[3]: 
			for i in player_door_coordinates["Level4"][1]:
				$World.set_cell(1, i, 0, Vector2i(0,0), -1)
			for i in player_door_coordinates["Level5"]:
				$World.set_cell(1, i, 0, Vector2i(0,0), -1)
		else:
			get_tree().paused = true
			$GameWon.show()
			$GameWon.display_stats()
	else:
		pass

func pause():
	get_tree().paused = true
	$RestartTimer.paused = true
	$PauseScreen.show()

func resume():
	get_tree().paused = false
	$RestartTimer.paused = false
	$PauseScreen.hide()

func _on_tree_exited():
	$MainMenu.save_data()
