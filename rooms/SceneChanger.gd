extends CanvasLayer
 
signal scene_changed()

onready var animation_player = $AnimationPlayer
onready var black = $Control/Black

func change_scene(path, delay = .5):
	pass
	
