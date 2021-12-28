extends "res://Actors/Ship.gd"

export var max_active_bullets = 3
export var friction = 500

var input_vector := Vector2.ZERO
var is_shot_charged = false
var charged_bullet_scene = preload("res://Bullets/ChargedBullet.tscn")

onready var charged_shot_timer:Timer = $ChargedShotTimer

func _physics_process(delta):
	# Detecting inputs
	var is_shooting = Input.is_action_just_pressed("shoot")
	var is_holding_shoot = Input.is_action_pressed("shoot")
	var released_shoot = Input.is_action_just_released("shoot")
	
	input_vector.x = Input.get_axis("ui_left", "ui_right")
	input_vector = input_vector.normalized()
	
	# Movement logic
	if input_vector != Vector2.ZERO:
		velocity = input_vector * move_speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction)

	velocity = move_and_slide(velocity)
	
	# Shooting logic
	check_bullets_alive()
	if is_shooting and len(active_bullets) < max_active_bullets:
		spawn_basic_bullet()
		charged_shot_timer.start()
		
	# Charged shot logic
	if released_shoot:
		charged_shot_timer.stop()
		
		if is_shot_charged:
			spawn_charged_bullet()
			is_shot_charged = false
	
	# Player cannot go over the edges of the world
	var player_half_width = sprite.texture.get_width() / 2
	position.x = clamp(position.x, 0 + player_half_width,  
	ProjectSettings.get_setting("display/window/size/width") - player_half_width)


func spawn_charged_bullet():
	# TODO: This method is a duplicate of `spawn_basic_bullet()`, i can fuse them
	var bullet = charged_bullet_scene.instance()
	bullet.position = shootingPoint.global_position
	
	active_bullets.append(bullet)
	get_tree().get_root().add_child(bullet)
	
	return bullet


func _on_ChargedShotTimer_timeout():
	is_shot_charged = true
