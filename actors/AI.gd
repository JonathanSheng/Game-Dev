extends Node2D

signal state_changed(new_state)

enum State { #List of integers, given names
	PATROL,
	ENGAGE
}
export (int) var SPEED = 50

onready var player_detection_zone = $PlayerDetectionZone
onready var patrol_timer = $PatrolTimer

var current_state: int = -1 setget set_state
var player: Player = null
var weapon: Weapon = null
var actor: KinematicBody2D = null

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
				actor.rotate_toward(patrol_location)
				if actor.global_position.distance_to(patrol_location) < 5:
					patrol_location_reached = true
					actor_velocity = Vector2.ZERO
					patrol_timer.start()
		State.ENGAGE:
			if player != null and weapon != null:
				#lerp smooths rotation, takes (from, to, weight)
				var angle_to_player = actor.global_position.direction_to(player.global_position).angle()
				actor.rotate_toward(player.global_position)
				if abs(actor.rotation - angle_to_player) <= 0.1: #Shoot only when angle at player
					weapon.shoot()
				#Enemy moves slowly towards player
				var direction = (player.global_position - actor.global_position).normalized()
				var motion = direction * SPEED * delta
				actor.position += motion
			else:
				print('Engaged, but no weapon/player')
		_:
			print('Error: found a state for our enemy that should not exist')
func initialize(actor, weapon: Weapon): #Can call AI for any actor
	self.actor = actor
	self.weapon = weapon

func set_state(new_state: int): #Setters for state changes, emit signal of state changed
	if new_state == current_state:
		return
	if new_state == State.PATROL:
		origin = global_position
		patrol_timer.start()
		patrol_location_reached = true
		
	current_state = new_state
	emit_signal("state_changed", current_state)


func _on_PlayerDetectionZone_body_entered(body : Node) -> void: 
	if body.is_in_group("player"): #We can allocate multiple things, player, allies, into a group so this still works
		set_state(State.ENGAGE)
		player = body


func _on_PlayerDetectionZone_body_exited(body): #Stops shooting and chasing when player leaves
	if player and body == player: #If there's a player and it the body exits is the player
		set_state(State.PATROL)
		player = null
		

func _on_PatrolTimer_timeout():
	var patrol_range = 50
	var random_x = rand_range(-patrol_range, patrol_range)
	var random_y = rand_range(-patrol_range, patrol_range)
	patrol_location = Vector2(random_x, random_y) + origin
	patrol_location_reached = false
	actor_velocity = actor.velocity_toward(patrol_location)
