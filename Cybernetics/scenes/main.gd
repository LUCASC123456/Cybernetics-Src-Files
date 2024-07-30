extends Node

signal enemy_killed

var max_enemies : int
var health : int
var enemies_left : int

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()
	$GameOver/Button.pressed.connect(new_game)
	
func new_game():
	max_enemies = 10
	health = 100
	enemies_left = max_enemies
	$Player.reset()
	get_tree().call_group("enemies", "queue_free")
	get_tree().call_group("bullets", "queue_free")
	$UI/EnemyCounter/EnemiesLabel.text = "ENEMIES LEFT: " + str(enemies_left)
	$UI/HealthBar.value = health
	$GameOver.hide()
	get_tree().paused = true
	$RestartTimer.start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_enemy_spawner_hit_p():
	health -= 10
	$UI/HealthBar.value = health
	if health <= 0:
		get_tree().paused = true
		$GameOver.show()

func _on_enemy_killed():
	enemies_left -= 1
	$UI/EnemyCounter/EnemiesLabel.text = "ENEMIES LEFT: " + str(enemies_left)
	if enemies_left <= 0:
		get_tree().paused = true
		$GameOver.show()

func _on_restart_timer_timeout():
	get_tree().paused = false
