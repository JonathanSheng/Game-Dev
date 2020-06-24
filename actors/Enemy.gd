extends KinematicBody2D

onready var stats = $StatsContainer
onready var ai = $AI
onready var weapon = $Weapon

func _ready() -> void:
	ai.initialize(self, weapon)

func handle_hit():
	stats.health -= 20
	if stats.health <= 0:
		queue_free()

