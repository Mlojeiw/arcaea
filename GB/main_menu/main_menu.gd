extends Control
@onready var background_shader = ShaderMaterial.new()
@onready var role = $Menu/Role
@onready var world = $Menu/World
@onready var background = $Menu/Background
@onready var start = $Menu/Start
@onready var story = $Menu/Story
@onready var course = $Menu/Course
@onready var more = $Menu/More
@onready var network = $Menu/NetWork
@onready var charicon = $Menu/Top/CharIconContainer/icon
@onready var charlist = $CharSelect/UserCharList
@onready var character = $CharSelect/Character
@onready var state = $CharSelect/State
@onready var charcontainer = $CharSelect/UserCharList
const CHARSELECTICON = preload("res://GB/main_menu/char_select_icon.tscn")
var background_tween : Tween
var offset_vec = Vector2(80,0)# 80 80
var select_position = Vector2(200,0)#init pos
var is_used = false
var total_h = 0
signal music_start
func _ready() -> void:
	singal_connect()
	setup()
func _process(delta: float) -> void:
	pass
func show_main_menu():
	if is_used:
		return
	is_used = true
	music_start.emit()
	show_main_menu_background()
	$MenuAnimation.play("BUTTON_MOVE")
func show_main_menu_background():
	background.position = Vector2(0,-700)
	background.material = background_shader
	await get_tree().process_frame
	if background_tween:
		background_tween.kill()
	background_tween = create_tween()
	background_tween.set_trans(Tween.TRANS_LINEAR)
	background_tween.set_loops()
	background_tween.tween_interval(5)
	background_tween.tween_property(background_shader,"shader_parameter/offset",Vector2(0,690),35)
	background_tween.tween_property(background_shader,"shader_parameter/offset",Vector2(0,-700),35)
	background_tween.tween_interval(5)
func reset():
	var data = UserData.char_list[UserData.current_char_id]
	is_used = false
	background_tween.kill()
	role.texture = data.texture[data.default]
	charicon.texture = data.icon[data.default]
	character.texture = data.texture[data.default]
	$CharSelectAnimation.play("RESET")
	$MenuAnimation.play("RESET")
	for x : CharIcon in charlist.get_children():
		x.anim_out()
func reflesh_main_menu():
	var data = UserData.char_list[UserData.current_char_id]
	role.texture = data.texture[data.default]
	charicon.texture = data.icon[data.default]
func _select_update(char:Char):
	for x: CharIcon in charlist.get_children():
		if x.id == char.id:
			x.charicon.texture_normal = char.icon[char.default] 
			x.anim_selecting()
		else:
			x.anim_selecting_cancel()
	character.texture = char.texture[char.default]
	character.position = Vector2(60,-4)
	character.modulate = Color(1,1,1,0)
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_parallel(true)
	tween.tween_property(character,"modulate",Color(1,1,1,1),0.2)
	tween.tween_property(character,"position",Vector2(-30,-4),0.2)
func setup():
	var data = UserData.char_list[UserData.current_char_id]
	role.texture = data.texture[data.default]
	charicon.texture = data.icon[data.default]
	character.texture = data.texture[data.default]
	for char:Char in UserData.char_list:
		var c = CHARSELECTICON.instantiate() as CharIcon
		charlist.add_child(c)
		c.setup(char,select_position)
		c.charicon.pressed.connect(func():UserData.current_char_id = c.id)
		select_position += Vector2(0,200)
		total_h += c.position.y
func _on_iconwreath_pressed() -> void:
	for child: CharIcon in charlist.get_children():
		child.anim_in()
	$CharSelectAnimation.play("CHAR_SELECT_IN")
func _on_exit_pressed() -> void:
	for child: CharIcon in charlist.get_children():
		child.anim_out()
	$CharSelectAnimation.play("CHAR_SELECT_OUT")
	reflesh_main_menu()
func _on_left_arrow_pressed() -> void:
	UserData.current_char_id += 1
func _on_right_arrow_pressed() -> void:
	UserData.current_char_id -= 1
func _on_partner_art_swap_pressed() -> void:
	var data = UserData.char_list[UserData.current_char_id]
	data.set_default()
#anim
func fade_in(node:TextureButton):
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(node,"modulate",Color(1,1,1,1),0.5)
func fade_out(node:TextureButton):
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(node,"modulate",Color(1,1,1,0.8),0.5)
func move_effect(picture,end_pos,duration):
	var move = create_tween()
	move.set_ease(Tween.EASE_IN_OUT)
	move.set_trans(Tween.TRANS_QUAD)
	move.tween_property(picture,"position",end_pos,duration)
func singal_connect():
	background_shader.shader = preload("res://GB/main_menu/background.gdshader")
	background_shader.set_shader_parameter("offset",Vector2.ZERO)
	start.mouse_entered.connect(fade_in.bind(start))
	start.mouse_exited.connect(fade_out.bind(start))
	world.mouse_entered.connect(fade_in.bind(world))
	world.mouse_exited.connect(fade_out.bind(world))
	course.mouse_entered.connect(fade_in.bind(course))
	course.mouse_exited.connect(fade_out.bind(course))
	story.mouse_entered.connect(fade_in.bind(story))
	story.mouse_exited.connect(fade_out.bind(story))
	more.mouse_entered.connect(fade_in.bind(more))
	more.mouse_exited.connect(fade_out.bind(more))
	network.mouse_entered.connect(fade_in.bind(network))
	network.mouse_exited.connect(fade_out.bind(network))
	UserData.char_switch.connect(_select_update)
	for x in UserData.char_list:
		x.default_switch.connect(_select_update)
