extends Control
class_name CharIcon
@onready var charicon = $charicon
@onready var was_selected = $was_selected
@onready var select = $select
@onready var char_name = $Label
var icon_list = [
	load("res://picture/character/charicon/0_icon.png"),
	load("res://picture/character/charicon/1_icon.png"),
]
var is_current_select
var id:int
var init_pos
func _ready() -> void:
	pass
func _process(delta: float) -> void:
	pass

func setup(char:Char,pos):
	self.position = pos
	init_pos = pos
	char_name.text = char.name
	id = char.id
	char_name.position = Vector2(-120,120)
	char_name.modulate = Color(1,1,1,0)
	charicon.modulate = Color(1,1,1,0)
	charicon.position = Vector2.ZERO
	charicon.texture_normal = char.icon[char.default]
	was_selected.position = Vector2(-6,-6)
	was_selected.modulate = Color(1,1,1,0)
	select.position = position + Vector2(-6,-6)
	select.modulate = Color(1,1,1,0)

func anim_in():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(charicon,"modulate",Color(1,1,1,1),0.2)
	tween.tween_property(char_name,"modulate",Color(1,1,1,1),0.2)
	if id == UserData.current_char_id:
		anim_selecting()

func anim_out():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_parallel(true)
	tween.tween_property(charicon,"modulate",Color(1,1,1,0),0.2)
	tween.tween_property(select,"modulate",Color(1,1,1,0),0.2)
	tween.tween_property(was_selected,"modulate",Color(1,1,1,0),0.2)
	tween.tween_property(char_name,"modulate",Color(1,1,1,0),0.2)
func anim_selecting():
	self.position = init_pos
	select.position =   Vector2(-6,-6) 
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_parallel(true)
	tween.tween_property(was_selected,"modulate",Color(1,1,1,1),0.2)
	tween.tween_property(self,"position",init_pos - Vector2(60,0),0.2)
	tween.tween_property(select,"modulate",Color(1,1,1,1),0.2)
	tween.tween_property(select,"position",select.position + Vector2(40,0),0.2)
func anim_selecting_cancel():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_parallel(true)
	tween.tween_property(was_selected,"modulate",Color(1,1,1,0),0.2)
	tween.tween_property(self,"position",init_pos,0.2)
	tween.tween_property(select,"modulate",Color(1,1,1,0),0.2)
	tween.tween_property(select,"position",select.position ,0.2)
