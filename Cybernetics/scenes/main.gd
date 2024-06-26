extends Node

signal enemy_killed

var max_enemies : int
var enemies_left : int
# Called when the node enters the scene tree for the first time.
func _ready():
	max_enemies = 10
	enemies_left = max_enemies
	$UI/EnemyCounter/EnemiesLabel.text = "Enemies Left: " + str(enemies_left)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_enemy_spawner_hit_p():
	pass

func _on_enemy_killed():
	enemies_left -= 1
	$UI/EnemyCounter/EnemiesLabel.text = "Enemies Left: " + str(enemies_left)
