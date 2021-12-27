# The basic ennemy. The average Joe, as they say.

extends "res://Actors/Ship.gd"

const STATE = preload("res://Actors/EnemyState.gd").EnemyState

var state = STATE.SPAWNING
var new_x_pos

onready var shoot_timer: Timer = $ShootTimer
onready var spawning_tween:Tween = $SpawningTween

func init(y_pos_after_spawn_tween=0):
	new_x_pos = y_pos_after_spawn_tween


func _ready():
	bullet_scene = preload("res://Bullets/EnemyBullet.tscn")
	#shoot_timer.start()	
	

func _physics_process(delta):
	# A really simple State Machine
	match state:
		STATE.SPAWNING:
			spawning_state()
		STATE.BASIC:
			basic_state()

func _on_ShootTimer_timeout():
	var bullet = spawn_basic_bullet()
	bullet.init(20, 1, get_groups()[0])
	

func spawning_state():
	if not spawning_tween.is_active():
		spawning_tween.interpolate_property(self, "position", position,
				Vector2(new_x_pos, position.y), 0.8, Tween.TRANS_EXPO, Tween.EASE_OUT)
		spawning_tween.start()


func basic_state():
	if shoot_timer.is_stopped():
		shoot_timer.start()


func set_state(new_state):
	# Sets the State to the new one
	state = new_state
