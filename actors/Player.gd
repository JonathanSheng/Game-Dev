extends KinematicBody2D
class_name Player

onready var weapon = $Weapon
onready var stats = $StatsContainer



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

func handle_hit():
	stats.health -= 20
	print('Player Hit', stats.health)
	
