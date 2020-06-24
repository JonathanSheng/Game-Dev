extends KinematicBody2D
class_name Player

export (int) var speed = 200 #Export enables editing in editor


onready var weapon = $Weapon
onready var health_stat = $Health

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
	movement_direction = movement_direction.normalized() #Diagonal has higher vector, this fixes it
	move_and_slide(movement_direction * speed) #Given vector * scalar, grants movement to kinematic
	look_at(get_global_mouse_position()) #Every frame, player looks at mouse

func _unhandled_input(event : InputEvent) -> void:
	if event.is_action_released('shoot'):
		weapon.shoot()

func handle_hit():
	health_stat.health -= 20
	print('Player Hit', health_stat.health)
	
