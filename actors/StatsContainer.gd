extends Node2D

export (int) var health = 100 setget set_health
export (int) var speed = 200  setget set_speed
export(int) var dex = 100 setget set_dex #Attack speed
export (int) var def = 20 setget set_def

func set_health (new_health : int) -> void:
	health = clamp(new_health, 0, 100) #Locks health between 0 and 100
func set_speed (new_speed: int) -> void:
	speed = clamp(new_speed, 0, 200)
func set_dex(new_dex: int) -> void:
	dex = clamp(new_dex, 0, 100)
func set_def(new_def : int) -> void:
	def = clamp(new_def, 0, 50)
