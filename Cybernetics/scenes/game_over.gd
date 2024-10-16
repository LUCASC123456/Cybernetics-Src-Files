extends CanvasLayer

@onready var main = get_node("/root/Main")
@onready var main_menu = get_node("/root/Main/MainMenu")

func display_stats():
	$Stats/CreditsEarned.text = "CREDITS EARNED: " + str(main.credits_earned)
	$Stats/EnemiesKilled.text = "ENEMIES KILLED: " + str(main.enemies_killed)
	$Stats/DamageInflicted.text = "DAMAGE INFLICTED: " + str(main.damage_inflicted)
	$Stats/DamageTaken.text = "DAMAGE TAKEN: " + str(main.damage_taken)
	$Stats/TimeTaken.text = "TIME TAKEN: " + str(main.time_taken)
	$Stats/BulletsFired.text = "BULLETS FIRED: " + str(main.bullets_fired)
	$Stats/LevelsCompleted.text = "LEVELS COMPLETED: " + str(main.levels_completed) + "/5"

func _on_exit_button_pressed():
	main_menu.credits += main.credits_earned
	main_menu.save_data()
	main._ready()
