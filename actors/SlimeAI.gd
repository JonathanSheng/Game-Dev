extends Node2D

signal state_changed(new_state)

enum State { #List of integers, given names
	PATROL,
	ENGAGE
}
export (int) var SPEED = 75

onready var patrol_timer = $PatrolTimer

var current_state: int = -1 setget set_state
var target: KinematicBody2D = null
var actor: KinematicBody2D = null
var team: int = -1

#Patrol state
var origin: Vector2 = global_position
var patrol_location: Vector2 = Vector2.ZERO
var patrol_location_reached: bool = false
var actor_velocity: Vector2	= Vector2.ZERO

func _ready() -> void:
	set_state(State.PATROL)
	

func _physics_process(delta: float) -> void:
	match current_state: #switch/if statement
		State.PATROL:
			if not patrol_location_reached:
				actor.move_and_slide(actor_velocity)
				if actor.global_position.distance_to(patrol_location) < 5:
					patrol_location_reached = true
					actor_velocity = Vector2.ZERO
					patrol_timer.start()
		State.ENGAGE:
			if target != null:
				#Add timer for slime to jump
				SPEED = 150
				#lerp smooths rotation, takes (from, to, weight)
				#Enemy moves slowly towards player
				var direction = (target.global_position - actor.global_position).normalized()
				var motion = direction * SPEED * delta
				actor.position += motion

			else:
				print('Engaged, but no weapon/target')
		_:
			print('Error: found a state for our enemy that should not exist')

func initialize(actor: KinematicBody2D, team: int): #Can call AI for any actor
	self.actor = actor
	self.team = team


func set_state(new_state: int): #Setters for state changes, emit signal of state changed
	if new_state == current_state:
		return
	if new_state == State.PATROL:
		origin = global_position
		patrol_timer.start()
		patrol_location_reached = true
		
	current_state = new_state
	emit_signal("state_changed", current_state)



func _on_PatrolTimer_timeout():
	var patrol_range = 50
	var random_x = rand_range(-patrol_range, patrol_range)
	var random_y = rand_range(-patrol_range, patrol_range)
	patrol_location = Vector2(random_x, random_y) + origin
	patrol_location_reached = false
	actor_velocity = actor.velocity_toward(patrol_location)


func _on_DetectionZone_body_entered(body: Node) -> void:
	#If the body that enters has a get_tema and if it's not on the same team then engage
	if body.has_method('get_team') and body.get_team() != team: 
		set_state(State.ENGAGE)
		target = body


func _on_DetectionZone_body_exited(body: Node) -> void:
	if target and body == target: #If there's a player and it the body exits is the player
		set_state(State.PATROL)
		target = null
