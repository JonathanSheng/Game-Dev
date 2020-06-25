extends Node2D

onready var bullet_manager = $BulletManager
onready var player: Player = $Player

func _ready():
	randomize() #Change random seed
	#Connects global signal fired bullet to bullet manager signal handle bullet
	GlobalSignals.connect("bullet_fired", bullet_manager, "handle_bullet_spawned")
	

