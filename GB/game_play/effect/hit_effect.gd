extends TextureRect

var tween:Tween
var init_pos_y = 720
func _ready() -> void:
	modulate = Color(1,1,1,0)

func anim():
	if tween:
		tween.kill()
	position.y = init_pos_y
	modulate = Color(1,1,1,0)
	tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self,"position",Vector2(position.x,init_pos_y - 80),0.2)
	tween.tween_property(self,"modulate",Color(1,1,1,1),0.2)
	await tween.finished
	modulate = Color(1,1,1,0)	
	tween.kill()
