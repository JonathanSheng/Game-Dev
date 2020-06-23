extends Node2D

onready var bullet_manager = $BulletManager
onready var player = $Player

func _ready():
	#Connects player signal fired bullet to bullet manager signal handle bullet
	player.connect("player_fired_bullet", bullet_manager, "handle_bullet_spawned")
	

