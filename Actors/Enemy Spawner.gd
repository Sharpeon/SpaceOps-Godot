extends Node2D

const STATE = preload("res://Actors/EnemyState.gd").EnemyState
const ENEMY_SCENE = preload("res://Actors/Enemy.tscn")

export (int) var enemy_per_line = 6
export (Vector2) var enemy_offset = Vector2.ZERO

var enemies = []
var game_width: float # The width that the ennemies can move in
var enemy_spacing: float # The distance between each ennemies
var texture_size: Vector2

onready var spawn_timer: Timer = $SpawnTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	# By defaut, the "anchor" of the sprite is in the center.
	# Because of that, when spawning them at (0,0) part of them is offscreen
	# We get an offset of the sprite's position to fix that.
	var enemy = ENEMY_SCENE.instance()
	var texture = enemy.get_child(0).texture
	texture_size = texture.get_size()
	
	enemy_offset.x += texture_size.x / 2
	enemy_offset.y = texture_size.y / 2
	
	# Calculating the available space width for the ennemies to move in
	game_width = ProjectSettings.get_setting("display/window/size/width")
	game_width -= enemy_offset.x * 2
	
	enemy_spacing = game_width / (enemy_per_line + 1)

func get_enemy_x_pos_after_spawning():
	# Returns the x position at which the enemy will be at the end of the
	# tweening animation. 
	var x_pos = (len(enemies) + 1) * enemy_spacing
	x_pos += texture_size.x / 2
	
	return x_pos


func _on_SpawnTimer_timeout():
	# Create an enemy when the timer times out.
	var enemy = ENEMY_SCENE.instance()
	enemy.position = Vector2(enemy_offset.x, enemy_offset.y)
	enemy.init(get_enemy_x_pos_after_spawning())
	# TODO: Put the enemy's position offscren, actually. think thats bettter
	
	enemies.append(enemy)
	get_tree().get_root().add_child(enemy)
	
	# Stop if enough enemies and switches all enemies states to BASIC
	if len(enemies) >= enemy_per_line:
		spawn_timer.stop()
		
		# TODO: Figure out a way to wait for the last enemy to tween before 
		# switching states
		for e in enemies:
			e.set_state(STATE.BASIC)
