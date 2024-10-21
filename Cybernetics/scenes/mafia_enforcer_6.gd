extends CharacterBody2D

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")
@onready var game_over = get_node("/root/Main/GameOver")
@onready var world = get_node("/root/Main/World")
@onready var health_bar = $EnemyHealthBar

@export var target : CharacterBody2D
@export var start_dir : String

var item_scene := preload("res://scenes/item.tscn")

var health : int
var speed : int
var alive : bool
var entered : bool
var damage_resistant : bool
var player_colliding : bool
var world_colliding : bool
var can_see_player : bool
var phantom : bool
var direction : Vector2
var vision_point : Vector2
const phantom_chance : float = 0.66

const basic_drop_chance : float = 0.75
const complex_drop_chance : float = 0.5

var minimap_icon = "enemy"
var marker_added : bool

func _ready() -> void:
	target = player
	alive = true
	entered = false
	health = 100
	speed = 150
	
	var dist = target.position - position
	if start_dir == "horizontal":
		direction.x = dist.x
		direction.y = 0
	elif start_dir == "vertical":
		direction.x = 0
		direction.y = dist.y

func _on_entrance_timer_timeout():
	entered = true

func _process(_delta):
	health_bar.value = health

func _physics_process(_delta: float) -> void:
	if alive:
		$AnimatedSprite2D.animation = "run"
		if entered:
			var exclusion_list := []
			
			for i in $Area2D.get_overlapping_bodies():
				if i != TileMap:
					exclusion_list.append(i.get_rid())
				else:
					pass
			
			for i in main.get_children():
				if i is CharacterBody2D:
					if i.name != "Player":
						if i.player_colliding:
							exclusion_list.append(i.get_rid())
						else:
							pass
					else:
						pass
				else:
					pass
			
			var space_state = get_world_2d().direct_space_state
			var query = PhysicsRayQueryParameters2D.create(global_transform.origin, player.global_transform.origin, 7, exclusion_list)
			var result = space_state.intersect_ray(query)
			direction = (target.position - position)
			
			if result:
				if result.collider == target:
					can_see_player = true
				else:
					can_see_player = false
				
				vision_point = result.position
				
			if phantom:
				$AnimatedSprite2D.modulate.a = 0.5
				damage_resistant = true
			else:
				$AnimatedSprite2D.modulate.a = 1
				damage_resistant = false
		else:
			damage_resistant = true
	
		direction = direction.normalized()
		velocity = direction * speed 
		move_and_slide()
		
		if velocity.x != 0:
			$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		pass

func _on_phantom_cool_down_timer_timeout():
	if alive and entered:
		if can_see_player:
			var probability = randf()
			
			if probability <= phantom_chance:
				phantom = true
				$PhantomTimer.start()
				$PhantomCoolDownTimer.stop()
			else:
				pass
		else:
			pass
	else:
		pass

func _on_phantom_timer_timeout():
	if not world_colliding:
		phantom = false
	else:
		pass
	
	$PhantomCoolDownTimer.start()

func hit_player_6():
	var damage : int
	
	if target.force_field_activated:
		damage = 0
	else:
		if main.levels[2]:
			damage = randi_range(10, 15)
		elif main.levels[3]:
			damage = randi_range(15, 20)
		else:
			pass
	
	if target.sheild > 0:
		target.sheild -= damage
		
		if target.sheild < 0:
			target.health += target.sheild
			target.sheild = 0
		else:
			pass
	else:
		target.health -= damage
	
	main.damage_taken += damage
	if main.credits_earned > 0:
		main.credits_earned -= damage
		if main.credits_earned <= 0:
			main.credits_earned = 0
		else:
			pass
	else:
		pass
		
	if target.health <= 0:
		get_tree().paused = true
		game_over.show()
		game_over.display_stats()
	else:
		pass

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		player_colliding = true
		if alive and entered:
			hit_player_6()
			$HitTimer.start()
		else:
			pass
	elif body.name == "World":
		world_colliding = true
		if alive and entered:
			phantom = true
		else:
			pass
	else:
		pass

func _on_hit_timer_timeout():
	hit_player_6()

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		player_colliding = false
		$HitTimer.stop()
	elif body.name == "World":
		world_colliding = true
		if $PhantomTimer.is_stopped():
			phantom = false
		else:
			pass
	else:
		pass

func die():
	z_index = 1
	collision_layer = 0
	alive = false
	phantom = false
	$HitTimer.stop()
	$PhantomCoolDownTimer.stop()
	$PhantomTimer.stop()
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.animation = "dead"
	$EnemyHealthBar.hide()
	main.enemy_killed.emit()
	
	var probability : float
	probability = randf()
	if probability <= basic_drop_chance:
		drop_item_basic()
	else:
		probability = randf()
		if probability <= complex_drop_chance:
			drop_item_complex()
		else:
			pass
			
func drop_item_basic():
	var item = item_scene.instantiate()
	item.position = position
	item.item_type = randi_range(0, 2)
	main.call_deferred("add_child", item)
	item.add_to_group("items")

func drop_item_complex():
	var item = item_scene.instantiate()
	item.position = position
	item.item_type = randi_range(3, 5)
	main.call_deferred("add_child", item)
	item.add_to_group("items")
