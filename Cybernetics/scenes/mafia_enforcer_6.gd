extends CharacterBody2D

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")

@export var target: Node2D = null
@export var start_dir : String

var item_scene := preload("res://scenes/item.tscn")
var can_see_player := false

var health : int
var speed : int
var alive : bool
var entered : bool
var damage_resistant : bool
var player_colliding : bool
var phantom_sight_reach : bool
var phantom_attack : bool
var phantom_collide : bool
var direction : Vector2
var vision_point = Vector2.ZERO
var exclusion_container : Array
const phantom_chance : float = 0.66

const basic_drop_chance : float = 0.75
const complex_drop_chance : float = 0.5

var minimap_icon = "enemy"
var marker_added : bool
var marker_removed : bool

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

func _physics_process(_delta: float) -> void:
	if alive:
		$AnimatedSprite2D.animation = "run"
		if entered:
			exclusion_container.clear()
			
			for i in $Area2D.get_overlapping_bodies():
				if i is TileMap:
					pass
				else:
					exclusion_container.append(i.get_rid())
			
			for i in main.get_children():
				if i is CharacterBody2D:
					if i.name != "Player":
						if i.player_colliding:
							exclusion_container.append(i.get_rid())
						else:
							pass
					else:
						pass
				else:
					pass
			
			var space_state = get_world_2d().direct_space_state
			var query = PhysicsRayQueryParameters2D.create(global_transform.origin, player.global_transform.origin, 7, exclusion_container)
			var result = space_state.intersect_ray(query)
			
			if result:
				if result.collider == target:
					can_see_player = true
				else:
					can_see_player = false
				
				vision_point = result.position
			
			if can_see_player:
				phantom_sight_reach = true
			else:
				phantom_sight_reach = false
				
			if phantom_collide or phantom_attack:
				$AnimatedSprite2D.modulate.a = 0.5
				damage_resistant = true
			elif phantom_collide == false and phantom_attack == false:
				$AnimatedSprite2D.modulate.a = 1
				damage_resistant = false
			
			direction = (target.position - position)
		else:
			damage_resistant = true
	
		direction = direction.normalized()
		velocity = direction * speed 
		move_and_slide()
		
		if velocity.x != 0:
			$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		pass

func _on_phantom_check_timer_timeout():
	if alive and entered:
		if phantom_sight_reach:
			var probability = randf()
			if probability < phantom_chance:
				phantom_attack = true
				$PhantomTimer.start()
				$PhantomCheckTimer.stop()
		else:
			pass
	else:
		pass

func _on_phantom_timer_timeout():
	phantom_attack = false
	$PhantomCheckTimer.start()

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		player_colliding = true
		if alive and entered:
			main.hit_player_6()
			$HitTimer.start()
		else:
			pass
	elif body.name == "World":
		if alive and entered:
			z_index = 6
			phantom_collide = true
		else:
			z_index = 3

func _on_hit_timer_timeout():
	main.hit_player_6()

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		player_colliding = false
		$HitTimer.stop()
	elif body.name == "World":
		z_index = 3
		phantom_collide = false
	else:
		pass

func die():
	z_index = 1
	collision_layer = 0
	alive = false
	marker_removed = true
	phantom_attack = false
	phantom_collide = false
	$HitTimer.stop()
	$PhantomCheckTimer.stop()
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
