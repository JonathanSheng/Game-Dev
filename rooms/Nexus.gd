extends Node2D


func _unhandled_input(event):
	if event.is_action_released('shoot'):
		get_tree().change_scene("res://Main.tscn")
