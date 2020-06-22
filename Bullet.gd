extends Area2D
class_name Bullet

export (int) var speed = 10
var direction := Vector2.ZERO
onready var kill_timer = $KillTimer
func _ready() -> void:
	kill_timer.start()
func _physics_process(delta: float) -> void:
	if direction != Vector2.ZERO:
		var velocity = direction * speed
		global_position += velocity

func set_direction(direction: Vector2):
	self.direction = direction
	rotation += direction.angle() #We altered bullet to 90 degrees originally


func _on_KillTimer_timeout():
	queue_free() #Destroys object after timeout
