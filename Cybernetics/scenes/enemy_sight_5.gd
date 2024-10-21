extends RayCast2D

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")
@onready var game_over = get_node("/root/Main/GameOver")

var is_casting: bool = false :
	set(value): 
		is_casting = value
		
		if is_casting:
			appear()
		else:
			disapear()
		
		set_physics_process(is_casting)
		
func _ready():
	$Line2D.points[1] = Vector2.ZERO
	is_casting = false

func _process(_delta):
	var cast_point_1 := target_position
	force_raycast_update()
	
	if is_colliding():
		cast_point_1 = to_local(get_collision_point())
	else:
		cast_point_1.x = 5000
		
	target_position = cast_point_1
	
	is_casting = get_parent().lazer_activated

func hit_player_5_lazer():
	var damage : int
	
	if player.force_field_activated:
		damage = 0
	else:
		damage = randi_range(20, 25)
	
	if player.sheild > 0:
		player.sheild -= damage
		
		if player.sheild < 0:
			player.health += player.sheild
			player.sheild = 0
		else:
			pass
	else:
		player.health -= damage
	
	main.damage_taken += damage
	if main.credits_earned > 0:
		main.credits_earned -= damage
		if main.credits_earned <= 0:
			main.credits_earned = 0
		else:
			pass
	else:
		pass
		
	if player.health <= 0:
		get_tree().paused = true
		game_over.show()
		game_over.display_stats()
	else:
		pass

func _physics_process(_delta: float) -> void:
	var cast_point_2 := target_position
	force_raycast_update()
	
	if is_colliding():
		cast_point_2 = to_local(get_collision_point())
		if get_collider().name == "Player":
			hit_player_5_lazer()
			$HitTimer2.start()
		else:
			$HitTimer2.stop()
	else:
		$HitTimer2.stop()
	
	$Line2D.points[1] = cast_point_2

func _on_hit_timer_2_timeout():
	hit_player_5_lazer()

func appear() -> void:
	var tween = create_tween()
	tween.tween_property($Line2D, "width", 10.0, 0.2)

func disapear() -> void:
	var tween = create_tween()
	tween.tween_property($Line2D, "width", 0, 0.1)
