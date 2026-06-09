extends Control
@onready var character = $Character
var offset_vec = Vector2(80,0)# 80 80
var select_position = Vector2(200,0)#init pos
var total_h = 0
var tween:Tween
const CHARSELECTICON = preload("res://GB/char_select/char_select_icon.tscn")
@onready var charlist = $UserCharList
signal exit
func _ready() -> void:
	signal_connect()
	_setup()
func _setup():
	visible = false
	for x:Char in UserData.char_list:
		var c = CHARSELECTICON.instantiate() as CharIcon
		charlist.add_child(c)
		c.setup(x,select_position)
		select_position += Vector2(0,200)
		total_h += c.position.y
	var data = UserData.char_list[UserData.current_char_id]
	character.texture = data.texture[data.default]
func _update(char:Char):
	character.texture = char.texture[char.default]
	character.position = Vector2(60,-4)
	character.modulate = Color(1,1,1,0)
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_parallel(true)
	tween.tween_property(character,"modulate",Color(1,1,1,1),0.2)
	tween.tween_property(character,"position",Vector2(-30,-4),0.2)
	for x: CharIcon in charlist.get_children():
		if x.id == char.id:
			x.charicon.texture_normal = char.icon[char.default] 
			x.anim_selecting()
		else:
			x.anim_selecting_cancel()
func reset():
	var data = UserData.char_list[UserData.current_char_id]
	character.texture = data.texture[data.default]
	$Anim.play("RESET")
	for x: CharIcon in charlist.get_children():
		x.reset()
func anim_in():
	visible = true
	$Anim.play("IN")
	for child: CharIcon in charlist.get_children():
		child.anim_in()
func anim_out():
	$Anim.play("OUT")
	for child: CharIcon in charlist.get_children():
		child.anim_out()
func _on_left_arrow_pressed() -> void:
	UserData.set_current_char_id(UserData.current_char_id + 1)
func _on_right_arrow_pressed() -> void:
	UserData.set_current_char_id(UserData.current_char_id - 1)
func _on_partner_art_swap_pressed() -> void:
	var data = UserData.char_list[UserData.current_char_id]
	data.add_default()
func _on_exit_pressed() -> void:
	anim_out()
	for x: CharIcon in charlist.get_children():
		x.reset()
	exit.emit()
func signal_connect():
	UserData.char_switch.connect(_update)
	for x in UserData.char_list:
		x.default_switch.connect(_update)
