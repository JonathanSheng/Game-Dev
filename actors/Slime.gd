extends KinematicBody2D

onready var stats: Node2D = $StatsContainer
onready var ai: Node2D = $SlimeAI
onready var team: Node2D = $Team


export (int) var speed = 100

func _ready() -> void:
	ai.initialize(self, team.team)

func handle_hit():
	stats.health -= 20
	if stats.health <= 0:
		queue_free()
		

func rotate_toward(location: Vector2) -> void:
	rotation = lerp(rotation, global_position.direction_to(location).angle(), .1)

func velocity_toward(location: Vector2) -> Vector2:
	return global_position.direction_to(location) * speed

func get_team() -> int:
	return team.team
