extends Node

signal enemy_killed

var health : int
var enemies_left : int

var enemy_level_count = [20, 30, 40, 50, 0]
var levels = [true, false, false, false, false]
var x_coordinates_level_1 = [6,7,8,9,6,7,8,9,15,15,15,15]
var y_coordinates_level_1 = [0,0,0,0,15,15,15,15,6,7,8,9]
var x_coordinates_level_2 = [24,24,24,24,32,33,34,35,44,45,46,47,32,33,34,35,44,45,46,47,55,55,55,55]
var y_coordinates_level_2 = [6,7,8,9,0,0,0,0,0,0,0,0,15,15,15,15,15,15,15,15,6,7,8,9]
var x_coordinates_level_3 = [65,66,67,68,35,35,35,35,98,98,98,98,65,66,67,68]
var y_coordinates_level_3 = [19,19,19,19,32,33,34,35,32,33,34,35,48,48,48,48]
var x_coordinates_level_4 = [127,128,129,130,122,122,122,122,122,122,122,122,144,145,146,147,148,149,150,151,152,174,174,174,174,174,174,174,174,167,168,169,170]
var y_coordinates_level_4 = [48,48,48,48,30,31,32,33,34,35,36,37,19,19,19,19,19,19,19,19,19,30,31,32,33,34,35,36,37,48,48,48,48]
var x_coordinates_level_5 = [167,168,169,170]
var y_coordinates_level_5 = [63,63,63,63]

func _ready():
	get_tree().paused = true
	$GameWon.credits_earned = 0
	$RestartTimer.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	
	$World/Level1/CollisionShape2D.set_deferred("disabled", false)
	$World/Level2/CollisionShape2D.set_deferred("disabled", false)
	$World/Level3/CollisionShape2D.set_deferred("disabled", false)
	$World/Level4/CollisionShape2D.set_deferred("disabled", false)
	$World/Level5/CollisionShape2D.set_deferred("disabled", false)
	
	get_tree().call_group("enemies_level_1", "queue_free")
	get_tree().call_group("enemies_level_2", "queue_free")
	get_tree().call_group("enemies_level_3", "queue_free")
	get_tree().call_group("enemies_level_4", "queue_free")
	get_tree().call_group("bullets", "queue_free")
	get_tree().call_group("items", "queue_free")
	
	for i in range(0, len(levels)):
		if i == 0:
			levels[i] = true
		else:
			levels[i] = false
	
	for i in range(8, len(x_coordinates_level_1)):
		$World.set_cell(1, Vector2i(x_coordinates_level_1[i], y_coordinates_level_1[i]), 0, Vector2i(0,0), 0)
	
	for i in range(0, len(x_coordinates_level_1)-4):
		$World.set_cell(1, Vector2i(x_coordinates_level_1[i], y_coordinates_level_1[i]), 0, Vector2i(1,1), 0)
			
	for i in range(4, len(x_coordinates_level_2)-4):
		$World.set_cell(1, Vector2i(x_coordinates_level_2[i], y_coordinates_level_2[i]), 0, Vector2i(1,1), 0)
		
	for i in range(20, len(x_coordinates_level_2)):
		$World.set_cell(1, Vector2i(x_coordinates_level_2[i], y_coordinates_level_2[i]), 0, Vector2i(0,0), 0)
		
	for i in range(4, len(x_coordinates_level_3)-4):
		$World.set_cell(1, Vector2i(x_coordinates_level_3[i], y_coordinates_level_3[i]), 0, Vector2i(1,1), 0)
		
	for i in range(12, len(x_coordinates_level_3)):
		$World.set_cell(1, Vector2i(x_coordinates_level_3[i], y_coordinates_level_3[i]), 0, Vector2i(0,0), 0)
		
	for i in range(4, len(x_coordinates_level_4)-4):
		$World.set_cell(1, Vector2i(x_coordinates_level_4[i], y_coordinates_level_4[i]), 0, Vector2i(1,1), 0)
			
	for i in range(29, len(x_coordinates_level_4)):
		$World.set_cell(1, Vector2i(x_coordinates_level_4[i], y_coordinates_level_4[i]), 0, Vector2i(0,0), 0)
		
	$UI.hide()
	$PauseScreen.hide()
	$GameOver.hide()
	$GameWon.hide()
	$MarketUI.hide()
	$NotEnoughCredits.hide()
	$MainMenu.show()
	
func new_game():
	if levels[0] == true:
		health = 100
		enemies_left = enemy_level_count[0]
		$Player._ready()
		print($Player/AnimatedSprite2D.position.x)
		$UI/EnemyCounter/EnemiesLabel.text = "ENEMIES LEFT: " + str(enemies_left)
		$UI/HealthBar.value = health
		$MainMenu.hide()
		$RestartTimer.start()
	elif levels[1] == true:
		health = 100
		enemies_left = enemy_level_count[1]
		$Player.reset()
		get_tree().call_group("enemies_level_1", "queue_free")
		get_tree().call_group("bullets", "queue_free")
		get_tree().call_group("items", "queue_free")
		$UI/EnemyCounter/EnemiesLabel.text = "ENEMIES LEFT: " + str(enemies_left)
		$UI/HealthBar.value = health
		$RestartTimer.start()
		
	elif levels[2] == true:
		health = 100
		enemies_left = enemy_level_count[2]
		$Player.reset()
		get_tree().call_group("enemies_level_2", "queue_free")
		get_tree().call_group("bullets", "queue_free")
		get_tree().call_group("items", "queue_free")
		$UI/EnemyCounter/EnemiesLabel.text = "ENEMIES LEFT: " + str(enemies_left)
		$UI/HealthBar.value = health
		$RestartTimer.start()
		
	elif levels[3] == true:
		health = 100
		enemies_left = enemy_level_count[3]
		$Player.reset()
		get_tree().call_group("enemies_level_3", "queue_free")
		get_tree().call_group("bullets", "queue_free")
		get_tree().call_group("items", "queue_free")
		$UI/EnemyCounter/EnemiesLabel.text = "ENEMIES LEFT: " + str(enemies_left)
		$UI/HealthBar.value = health
		$RestartTimer.start()
		
	elif levels[4] == true:
		health = 100
		enemies_left = enemy_level_count[4]
		$Player.reset()
		get_tree().call_group("enemies_level_4", "queue_free")
		get_tree().call_group("bullets", "queue_free")
		get_tree().call_group("items", "queue_free")
		$UI/EnemyCounter/EnemiesLabel.text = "ENEMIES LEFT: " + str(enemies_left)
		$UI/HealthBar.value = health
		$RestartTimer.start()

func pause():
	get_tree().paused = true
	$PauseScreen.show()
	$EnemySpawner/Timer.stop()
	$CreditTimer.stop()

func resume():
	get_tree().paused = false
	$PauseScreen.hide()
	$EnemySpawner/Timer.start()
	$CreditTimer.start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(_delta):
	pass

func _on_enemy_spawner_hit_p():
	var random = randi_range(10, 30)
	health -= random
	if $GameWon.credits_earned > 0:
		$GameWon.credits_earned -= random
		if $GameWon.credits_earned < 0:
			$GameWon.credits_earned = 0
		else:
			pass
	else:
		pass
	$UI/HealthBar.value = health
	if health <= 0 and $UI/HealthBar.value <= 0:
		get_tree().paused = true
		$CreditTimer.stop()
		$EnemySpawner/Timer.stop()
		$GameOver.show()

func _on_enemy_killed():
	enemies_left -= 1
	$UI/EnemyCounter/EnemiesLabel.text = "ENEMIES LEFT: " + str(enemies_left)
	if enemies_left <= 0:
		if levels[0] == true:
			$CreditTimer.stop()
			$EnemySpawner/Timer.stop()
			for i in range(8, len(x_coordinates_level_1)):
				$World.set_cell(1, Vector2i(x_coordinates_level_1[i], y_coordinates_level_1[i]), 0, Vector2i(0,0), -1)
			for i in range(0, len(x_coordinates_level_2)-20):
				$World.set_cell(1, Vector2i(x_coordinates_level_2[i], y_coordinates_level_2[i]), 0, Vector2i(0,0), -1)
		elif levels[1] == true:
			$CreditTimer.stop()
			$EnemySpawner/Timer.stop()
			for i in range(20, len(x_coordinates_level_2)):
				$World.set_cell(1, Vector2i(x_coordinates_level_2[i], y_coordinates_level_2[i]), 0, Vector2i(0,0), -1)
			for i in range(0, len(x_coordinates_level_3)-12):
				$World.set_cell(1, Vector2i(x_coordinates_level_3[i], y_coordinates_level_3[i]), 0, Vector2i(0,0), -1)
		elif levels[2] == true: 
			$CreditTimer.stop()
			$EnemySpawner/Timer.stop()
			for i in range(12, len(x_coordinates_level_3)):
				$World.set_cell(1, Vector2i(x_coordinates_level_3[i], y_coordinates_level_3[i]), 0, Vector2i(0,0), -1)
			for i in range(0, len(x_coordinates_level_4)-29):
				$World.set_cell(1, Vector2i(x_coordinates_level_4[i], y_coordinates_level_4[i]), 0, Vector2i(0,0), -1)
		elif levels[3] == true: 
			$CreditTimer.stop()
			$EnemySpawner/Timer.stop()
			for i in range(29, len(x_coordinates_level_4)):
				$World.set_cell(1, Vector2i(x_coordinates_level_4[i], y_coordinates_level_4[i]), 0, Vector2i(0,0), -1)
			for i in range(0, len(x_coordinates_level_5)):
				$World.set_cell(1, Vector2i(x_coordinates_level_5[i], y_coordinates_level_5[i]), 0, Vector2i(0,0), -1)
		elif levels[4] == true:
			$CreditTimer.stop()
			get_tree().paused = true
			$GameWon/CreditsEarned.text = "CREDITS EARNED: " + str($GameWon.credits_earned)
			$GameWon.show()
		else:
			pass

func _on_restart_timer_timeout():
	if levels[0] == true:
		$UI.show()
		$CreditTimer.start()
		$EnemySpawner/Timer.start()
		get_tree().paused = false
		for i in range(0, len(x_coordinates_level_1)-4):
			$World.set_cell(1, Vector2i(x_coordinates_level_1[i], y_coordinates_level_1[i]), 0, Vector2i(1,1), -1)
		$RestartTimer.process_mode = Node.PROCESS_MODE_INHERIT
		$Player/AnimatedSprite2D/Camera2D.process_mode = Node.PROCESS_MODE_INHERIT
		$Player/AnimatedSprite2D/Camera2D.position_smoothing_enabled = true
		$Player/AnimatedSprite2D/Camera2D.drag_horizontal_enabled = true
		$Player/AnimatedSprite2D/Camera2D.drag_vertical_enabled = true
	elif levels[1] == true:
		$EnemySpawner/Timer.start()
		$CreditTimer.start()
		for i in range(4, len(x_coordinates_level_2)-4):
			$World.set_cell(1, Vector2i(x_coordinates_level_2[i], y_coordinates_level_2[i]), 0, Vector2i(1,1), -1)
		for i in range(0, len(x_coordinates_level_2)-20):
			$World.set_cell(1, Vector2i(x_coordinates_level_2[i], y_coordinates_level_2[i]), 0, Vector2i(0,0), 0)
			if $Player.position.x < 1225:
				$Player.position.x = 1275
				$Player.position.y = 384
			else:
				pass
	elif levels[2] == true:
		$EnemySpawner/Timer.start()
		$CreditTimer.start()
		for i in range(4, len(x_coordinates_level_3)-4):
			$World.set_cell(1, Vector2i(x_coordinates_level_3[i], y_coordinates_level_3[i]), 0, Vector2i(1,1), -1)
		for i in range(0, len(x_coordinates_level_3)-12):
			$World.set_cell(1, Vector2i(x_coordinates_level_3[i], y_coordinates_level_3[i]), 0, Vector2i(0,0), 0)
		if $Player.position.y < 985:
			$Player.position.x = 3216
			$Player.position.y = 1035
		else:
			pass
	elif levels[3] == true:
		$EnemySpawner/Timer.start()
		$CreditTimer.start()
		for i in range(4, len(x_coordinates_level_4)-4):
			$World.set_cell(1, Vector2i(x_coordinates_level_4[i], y_coordinates_level_4[i]), 0, Vector2i(1,1), -1)
		for i in range(0, len(x_coordinates_level_4)-29):
			$World.set_cell(1, Vector2i(x_coordinates_level_4[i], y_coordinates_level_4[i]), 0, Vector2i(0,0), 0)
		if $Player.position.y > 2279:
			$Player.position.x = 6192.5
			$Player.position.y = 2229
		else:
			pass
	elif levels[4] == true:
		$EnemySpawner/Timer.start()
		$CreditTimer.start()
	else:
		pass

func _on_credit_timer_timeout():
	if $GameWon.credits_earned > 0:
		$GameWon.credits_earned -= 2
		if $GameWon.credits_earned < 0:
			$GameWon.credits_earned = 0
		else:
			pass
	else:
		pass

func _on_tree_entered():
	$MainMenu.load_data()

func _on_tree_exited():
	$MainMenu.save_data()
