extends "res://Actors/Ship.gd"

export var max_active_bullets = 3
export var speed =  450
export var friction = 500

var input_vector := Vector2.ZERO


func _physics_process(delta):
	# Detecting inputs
	var is_shooting = Input.is_action_just_pressed("shoot")
	
	input_vector.x = Input.get_axis("ui_left", "ui_right")
	input_vector = input_vector.normalized()
	
	# Movement logic
	if input_vector != Vector2.ZERO:
		velocity = input_vector * speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction)

	velocity = move_and_slide(velocity)
	
	# Shooting logic
	check_bullets_alive()
	if is_shooting and len(active_bullets) < max_active_bullets:
		spawn_basic_bullet()
	
	# Player cannot go over the edges of the world
	var player_half_width = sprite.texture.get_width() / 2
	position.x = clamp(position.x, 0 + player_half_width,  
	ProjectSettings.get_setting("display/window/size/width") - player_half_width)
