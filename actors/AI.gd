extends Node2D

signal state_changed(new_state)

enum State { #List of integers, given names
	PATROL,
	ENGAGE
}
export (int) var SPEED = 50

onready var player_detection_zone = $PlayerDetectionZone
onready var patrol_timer = $PatrolTimer

var current_state: int = State.PATROL setget set_state
var player: Player = null
var weapon: Weapon = null
var actor = null
var origin: Vector2 = global_position

func _process(delta: float) -> void:
	match current_state: #switch/if statement
		State.PATROL:
			pass
		State.ENGAGE:
			if player != null and weapon != null:
				#lerp smooths rotation, takes (from, to, weight)
				var angle_to_player = actor.global_position.direction_to(player.global_position).angle()
				actor.rotation = lerp(actor.rotation, angle_to_player, 0.1)
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
		patrol_timer.start()
		
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
		
