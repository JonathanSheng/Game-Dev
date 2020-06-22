extends KinematicBody2D
export (int) var speed = 200 #Export enables editing in editor
export (PackedScene) var Bullet
signal player_fired_bullet(bullet, position, direction)
onready var end_of_gun = $EndOfGun # $ finds child node
onready var gun_direction = $GunDirection
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta: float) -> void: #Called every frame, looks for input
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
		shoot()
func shoot():
	var bullet_instance = Bullet.instance() #Create new scene with bullet
	var direction = (gun_direction.global_position - end_of_gun.global_position).normalized()
	emit_signal("player_fired_bullet", bullet_instance, end_of_gun.global_position, direction)
	
