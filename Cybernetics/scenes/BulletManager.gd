extends Node2D

@export var bullet_scene : PackedScene

#generate a bullet whenever the player uses the bullet input by setting up the base position and 
#direction based on input so the bullet functionality is handled well
func _on_player_shoot(pos, dir):
	var bullet = bullet_scene.instantiate()
	add_child(bullet)
	bullet.position = pos
	bullet.direction = dir.normalized()
	bullet.add_to_group("bullets")
