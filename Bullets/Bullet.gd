extends Area2D

export (float) var move_speed = -20
export (int) var damage = 1

var my_group = "Player"
var screen_height = ProjectSettings.get_setting("display/window/size/height")


func init(move_spd, dmg, group):
	if move_spd:
		self.move_speed = move_spd
	if dmg:
		self.damage = dmg
	if not group == null and not group == "":
		self.my_group = group

func _physics_process(delta):
	despawn_bullet_offscreen()
	position.y += move_speed


func despawn_bullet_offscreen():
	if position.y < 0 or position.y > screen_height:
		queue_free()


func _on_Bullet_body_entered(body):
	if not body.is_in_group(my_group):
		body.lose_hp(damage)
		queue_free()
