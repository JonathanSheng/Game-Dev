extends KinematicBody2D
class_name Player

onready var weapon: Weapon = $Weapon
onready var stats: Node2D = $StatsContainer
onready var team: Node2D = $Team
export (int) var attack = 20
func _ready() -> void:
	weapon.initialize(team.team)

func _physics_process(delta: float) -> void: #Called every frame, looks for input
	var movement_direction := Vector2.ZERO #:= enables var to be same type as right side
	if Input.is_action_pressed("up"): #parameter created in project settings input map
		movement_direction.y = -1
	if Input.is_action_pressed("down"): 
		movement_direction.y = 1
	if Input.is_action_pressed("right"): 
		movement_direction.x = 1
	if Input.is_action_pressed("left"): 
		movement_direction.x = -1
	if Input.is_action_pressed('shoot'): #Hold down shooting
		weapon.shoot()
	movement_direction = movement_direction.normalized() #Diagonal has higher vector, this fixes it
	move_and_slide(movement_direction * stats.speed) #Given vector * scalar, grants movement to kinematic
	look_at(get_global_mouse_position()) #Every frame, player looks at mouse

func _unhandled_input(event):
	if event.is_action_released('Reload'):
		weapon.start_reload()
func get_team() -> int:
	return team.team
	
func handle_hit():
	stats.health -= (attack * 100 / (100 +stats.def))
	if stats.health <= 0:
		$"/root/SceneChanger".change_scene("res://rooms/Nexus.tscn")

	
func reload():
	weapon.start_reload()


func _on_Area2D_body_entered(body):
	$"/root/SceneChanger".change_scene("res://rooms/Main.tscn")
