extends KinematicBody2D

onready var stats = $StatsContainer
onready var ai = $AI
onready var weapon = $Weapon

export (int) var speed = 100
func _ready() -> void:
	ai.initialize(self, weapon)

func handle_hit():
	stats.health -= 20
	if stats.health <= 0:
		queue_free()

func rotate_toward(location: Vector2) -> void:
	rotation = lerp(rotation, global_position.direction_to(location).angle(), .1)

func velocity_toward(location: Vector2) -> Vector2:
	return global_position.direction_to(location) * speed
