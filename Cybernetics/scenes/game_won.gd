extends CanvasLayer

@onready var main = get_node("/root/Main")
@onready var main_menu = get_node("/root/Main/MainMenu")

#display stats by converting certain figures based on gameplay to string to give the end user and idea
#of how well they did
func display_stats():
	$Stats/CreditsEarned.text = "TOTAL CREDITS EARNED: " + str(main.credits_earned) + " CREDITS"
	$Stats/EnemiesKilled.text = "TOTAL ENEMIES KILLED: " + str(main.enemies_killed) + " ENEMIES"
	$Stats/DamageInflicted.text = "TOTAL DAMAGE INFLICTED: " + str(main.damage_inflicted) + " HEALTH"
	$Stats/DamageTaken.text = "TOTAL DAMAGE TAKEN: " + str(main.damage_taken) + " HEALTH"
	$Stats/TimeTaken.text = "TOTAL TIME TAKEN: " + str(main.time_taken) + " SECONDS"
	$Stats/BulletsFired.text = "TOTAL BULLETS FIRED: " + str(main.bullets_fired) + " ROUNDS"
	$Stats/LevelsCompleted.text = "LEVELS COMPLETED: " + str(main.levels_completed) + "/5 LEVELS"

#when the player presses the exit button, add the credits earned to the players total credits, save
#this data in the save file and bring the player to the main menu so the game can restart
func _on_exit_button_pressed():
	main_menu.credits += main.credits_earned
	main_menu.save_data()
	main._ready()
