# An "Abstract" Scene/Script for the Battleships. Not made
# to be instantiated, just inherited from.

extends KinematicBody2D

export (int, 1, 1000) var max_hp = 5

var velocity: Vector2 = Vector2.ZERO
var bullet_scene = preload("res://Bullets/Bullet.tscn")
var active_bullets = []

onready var hp = max_hp
onready var sprite: Sprite = $Sprite
onready var shootingPoint: Node2D = $ShootingPoint

func lose_hp(dmg):
	hp -= dmg
	
	# Dying logic
	if hp <= 0 :
		queue_free()
		# TODO: Add some cool particles when i know how


func spawn_basic_bullet():
	var bullet = bullet_scene.instance()
	bullet.position = shootingPoint.global_position
	
	active_bullets.append(bullet)
	get_tree().get_root().add_child(bullet)
	
	return bullet


func check_bullets_alive():
	# Checks if the bullets still exists. Removes them from
	# active_bullets if it doesnt anymore.
	
	for bullet in active_bullets:
		if not is_instance_valid(bullet):
			active_bullets.erase(bullet)
