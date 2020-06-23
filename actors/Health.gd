extends Node2D

export (int) var health = 100 setget set_health

func set_health (new_health : int) -> void:
	health = clamp(new_health, 0, 200) #Locks health between 0 and 100
