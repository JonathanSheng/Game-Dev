extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/VBoxContainer/VBoxContainer/StartGame.grab_focus()

func _physics_process(delta):
	if $MarginContainer/VBoxContainer/VBoxContainer/StartGame.is_hovered():
		$MarginContainer/VBoxContainer/VBoxContainer/StartGame.grab_focus()
	if $MarginContainer/VBoxContainer/VBoxContainer/QuitGame.is_hovered():
		$MarginContainer/VBoxContainer/VBoxContainer/QuitGame.grab_focus()


func _on_StartGame_pressed():
	$"/root/SceneChanger".change_scene("res://rooms/Nexus.tscn")

func _on_QuitGame_pressed():
	get_tree().quit()
