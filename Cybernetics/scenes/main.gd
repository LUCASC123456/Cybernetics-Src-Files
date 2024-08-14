extends Node

signal enemy_killed

var max_enemies : int
var health : int
var enemies_left : int
var random : int

var enemy_level_count = [20, 30, 40, 50]
var levels = [true, false, false, false, false]

func _ready():
	for i in range(0, len(levels)):
		if i == 0:
			levels[i] = true
		else:
			levels[i] = false
	get_tree().paused = true
	$UI.hide()
	$PauseScreen.hide()
	$GameOver.hide()
	$GameWon.hide()
	$MarketUI.hide()
	$NotEnoughCredits.hide()
	$MainMenu.show()

func sum(array):
	var result = 0
	for i in array:
		result += i
	return result
	
func new_game():
	max_enemies = sum(enemy_level_count)
	health = 100
	enemies_left = max_enemies
	$Player.reset()
	get_tree().call_group("enemies_level_1", "queue_free")
	get_tree().call_group("enemies_level_2", "queue_free")
	get_tree().call_group("enemies_level_3", "queue_free")
	get_tree().call_group("enemies_level_4", "queue_free")
	get_tree().call_group("bullets", "queue_free")
	get_tree().call_group("items", "queue_free")
	$UI/EnemyCounter/EnemiesLabel.text = "ENEMIES LEFT: " + str(enemies_left)
	$UI/HealthBar.value = health
	$MainMenu.hide()
	$MainMenu.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	$RestartTimer.start()

func pause():
	get_tree().paused = true
	$PauseScreen.show()
	$CreditTimer.stop()

func resume():
	get_tree().paused = false
	$PauseScreen.hide()
	$CreditTimer.start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(_delta):
	pass

func _on_enemy_spawner_hit_p():
	random = randi_range(10, 30)
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
		$GameWon.credits_earned = 0
		$CreditTimer.stop()
		$GameOver.show()

func _on_enemy_killed():
	enemies_left -= 1
	$UI/EnemyCounter/EnemiesLabel.text = "ENEMIES LEFT: " + str(enemies_left)
	if enemies_left <= 0:
		get_tree().paused = true
		$CreditTimer.stop()
		$GameWon/CreditsEarned.text = "CREDITS EARNED: " + str($GameWon.credits_earned)
		$GameWon.show()

func _on_restart_timer_timeout():
	$UI.show()
	$CreditTimer.start()
	get_tree().paused = false


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
