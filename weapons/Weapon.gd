extends Node2D
class_name Weapon

signal weapon_out_of_ammo 

export (PackedScene) var Bullet

var team: int = -1
var max_ammo: int = 10
var current_ammo: int = max_ammo

onready var end_of_gun = $EndOfGun # $ finds child node
onready var gun_direction = $GunDirection
onready var attack_cooldown = $AttackCooldown
onready var animation_player = $AnimationPlayer
onready var muzzle_flash = $MuzzleFlash

func _ready() -> void:
	muzzle_flash.hide()

func initialize(team: int) -> void:
	self.team = team
	
func start_reload():
	animation_player.play("Reload") #Play animation of reloading

func _stop_reload(): #_ infront means private function in this script
	current_ammo = max_ammo #Animation calls _stop_reload when done and reduces ammo
	

func shoot():
	if current_ammo > 0 and attack_cooldown.is_stopped() and Bullet != null:
		var bullet_instance = Bullet.instance() #Create new scene with bullet
		var direction = (gun_direction.global_position - end_of_gun.global_position).normalized()
		GlobalSignals.emit_signal("bullet_fired", bullet_instance, team, end_of_gun.global_position, direction)
		attack_cooldown.start()
		animation_player.play("muzzle_flash")
		current_ammo -= 1
		if current_ammo == 0:
			emit_signal("weapon_out_of_ammo")
