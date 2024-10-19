extends CanvasLayer

@onready var main = get_node("/root/Main")
@onready var main_menu = get_node("/root/Main/MainMenu")

func display_stats():
	$Stats/CreditsEarned.text = "TOTAL CREDITS EARNED: " + str(main.credits_earned) + " CREDITS"
	$Stats/EnemiesKilled.text = "TOTAL ENEMIES KILLED: " + str(main.enemies_killed) + " ENEMIES"
	$Stats/DamageInflicted.text = "TOTAL DAMAGE INFLICTED: " + str(main.damage_inflicted) + " HEALTH"
	$Stats/DamageTaken.text = "TOTAL DAMAGE TAKEN: " + str(main.damage_taken) + " HEALTH"
	$Stats/TimeTaken.text = "TOTAL TIME TAKEN: " + str(main.time_taken) + " SECONDS"
	$Stats/BulletsFired.text = "TOTAL BULLETS FIRED: " + str(main.bullets_fired) + " ROUNDS"
	$Stats/LevelsCompleted.text = "LEVELS COMPLETED: " + str(main.levels_completed) + "/5 LEVELS"

func _on_exit_button_pressed():
	main_menu.credits += main.credits_earned
	main_menu.save_data()
	main._ready()
