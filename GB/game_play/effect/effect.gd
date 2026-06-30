extends Sprite3D
var tween:Tween
var is_anim:bool
func _ready() -> void:
	is_anim = false
	modulate = Color(1,1,1,0)
	
func anim_start():
	if is_anim:
		return
	is_anim = true
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self,"modulate",Color(1,1,1,0.4),0.05)
func anim_end():
	if not is_anim:
		return
	if tween:
		tween.kill()
	tween = create_tween() 
	tween.tween_property(self,"modulate",Color(1,1,1,0),0.05)
	is_anim = false
