extends Node

signal enemy_killed

var max_enemies : int
var health : int
var enemies_left : int

# Called when the node enters the scene tree for the first time.
func _ready():
	$UI.hide()
	$PauseScreen.hide()
	$GameOver.hide()
	$MainMenu.show()
	$MainMenu/PlayButton.pressed.connect(new_game)
	
func new_game():
	max_enemies = 10
	health = 100
	enemies_left = max_enemies
	$Player.reset()
	get_tree().call_group("enemies", "queue_free")
	get_tree().call_group("bullets", "queue_free")
	get_tree().call_group("items", "queue_free")
	$UI/EnemyCounter/EnemiesLabel.text = "ENEMIES LEFT: " + str(enemies_left)
	$UI/HealthBar.value = health
	$MainMenu.hide()
	$MainMenu.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	get_tree().paused = true
	$RestartTimer.start()

func pause():
	get_tree().paused = true
	$PauseScreen.show()
	$PauseScreen/ResumeButton.pressed.connect(resume)
	$PauseScreen/ExitButton.pressed.connect(_ready)
	
func resume():
	get_tree().paused = false
	$PauseScreen.hide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$UI/PauseButton.pressed.connect(pause)

func _on_enemy_spawner_hit_p():
	health -= randi_range(10, 30)
	$UI/HealthBar.value = health
	if health <= 0 and $UI/HealthBar.value <= 0:
		get_tree().paused = true
		$GameOver.show()
		$GameOver/ExitButton.pressed.connect(_ready)

func _on_enemy_killed():
	enemies_left -= 1
	$UI/EnemyCounter/EnemiesLabel.text = "ENEMIES LEFT: " + str(enemies_left)
	if enemies_left <= 0:
		get_tree().paused = true
		$GameOver.show()
		$GameOver/ExitButton.pressed.connect(_ready)

func _on_restart_timer_timeout():
	$UI.show()
	get_tree().paused = false
