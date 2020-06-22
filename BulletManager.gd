extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func handle_bullet_spawned(bullet:Bullet, position: Vector2, direction:Vector2):
	add_child(bullet)
	bullet.global_position = position
	bullet.set_direction(direction)
