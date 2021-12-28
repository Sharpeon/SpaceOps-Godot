# The basic ennemy. The average Joe, as they say.

extends "res://Actors/Ship.gd"

const STATE = preload("res://Actors/EnemyState.gd").EnemyState
enum {
	LEFT = -1,
	RIGHT = 1,
	DOWN = 0
}

var state = STATE.SPAWNING
var direction = RIGHT
var destination = Vector2.ZERO
var new_x_pos
var enemy_offset
var game_width: float # The width that the ennemies can move in
var game_height: float # The height that the ennemies can move in

onready var shoot_timer: Timer = $ShootTimer
onready var move_down_timer: Timer = $MoveDownTimer
onready var spawning_tween:Tween = $SpawningTween

func init(y_pos_after_spawn_tween=0, offset=0):
	new_x_pos = y_pos_after_spawn_tween
	enemy_offset = offset


func _ready():
	bullet_scene = preload("res://Bullets/EnemyBullet.tscn")
	game_width = ProjectSettings.get_setting("display/window/size/width")
	game_height = ProjectSettings.get_setting("display/window/size/height")
	game_width -= enemy_offset.x * 2
	game_height -= enemy_offset.y * 2
	
func _physics_process(delta):
	# A really simple State Machine
	match state:
		STATE.SPAWNING:
			spawning_state()
		STATE.BASIC:
			basic_state(delta)
	

func spawning_state():
	if not spawning_tween.is_active():
		spawning_tween.interpolate_property(self, "position", position,
				Vector2(new_x_pos, position.y), 0.8, Tween.TRANS_EXPO, Tween.EASE_OUT)
		spawning_tween.start()


func basic_state(delta):
	if shoot_timer.is_stopped():
		shoot_timer.start()
	
	if direction in [RIGHT, LEFT]:
		position.x += direction * move_speed * delta
		position.x = clamp(position.x, enemy_offset.x * 2, game_width)
		
		if position.x in [enemy_offset.x * 2, game_width]: # Hit an extremity
			direction = DOWN
	elif direction == DOWN:
		if move_down_timer.is_stopped():
			move_down_timer.start()
		
		position.y += move_speed * delta

func set_state(new_state):
	# Sets the State to the new one
	state = new_state


func _on_ShootTimer_timeout():
	var bullet = spawn_basic_bullet()
	bullet.init(20, 1, get_groups()[0])


func _on_MoveDownTimer_timeout():
	move_down_timer.stop()
	if position.x > game_width / 2:
		direction = LEFT
	else:
		direction = RIGHT
