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
var char_init_pos = Vector2(1000,100)
var role_list = [
	load("res://picture/character/char/0.png"),
	load("res://picture/character/char/0o.png"),
	load("res://picture/character/char/0u.png"),
	load("res://picture/character/char/1.png"),
	load("res://picture/character/char/1o.png"),
	load("res://picture/character/char/1u.png"),
]
var icon_list = [
	load("res://picture/character/charicon/0_icon.png"),
	load("res://picture/character/charicon/0o_icon.png"),
	load("res://picture/character/charicon/0u_icon.png"),
	load("res://picture/character/charicon/1_icon.png"),
	load("res://picture/character/charicon/1o_icon.png"),
	load("res://picture/character/charicon/1u_icon.png"),
]
var background_tween : Tween
var offset_vec = Vector2(80,0)# 80 80
var is_used = false
signal music_start
func _ready() -> void:
	singal_connect()
	_update(UserData.current_char_id)
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
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background.set_anchor(0,0,0,0)
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

func fade_in(node:TextureButton):
	var tween =create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(node,"modulate",Color(1,1,1,1),0.5)
func fade_out(node:TextureButton):
	var tween =create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(node,"modulate",Color(1,1,1,0.8),0.5)
func move_effect(picture,end_pos,duration):
	var move = create_tween()
	move.set_ease(Tween.EASE_IN_OUT)
	move.set_trans(Tween.TRANS_QUAD)
	move.tween_property(picture,"position",end_pos,duration)
func reset():
	is_used = false
	background_tween.kill()
	
func singal_connect():
	background_shader.shader = preload("res://main_menu/background.gdshader")
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
	UserData.char_switch.connect(_update)
func _update(value:int):
	role.texture = role_list[value]
	charicon.texture = icon_list[value]
	$CharSelect/Character.texture = role_list[value]
	#for r in UserData.user_char_list:
		#match r:
			#"Hikari":
				#var container = Control.new()
				#container.position = char_init_pos
				#char_init_pos += Vector2(0,100)
				#var hikari = TextureRect.new()
				#hikari.texture_normal = icon_list[0]
				#hikari.modulate = Color(1,1,1,0)
				#hikari.z_index = 7
				#container.add_child(hikari)
				#var wreath = TextureButton.new()
				#wreath.modulate = Color(1,1,1,0)
				#wreath.z_index = 7
			#"Tairitsu":
				#var container = Control.new()
				#container.position = char_init_pos
				#char_init_pos += Vector2(0,100)
				#var tairitsu = TextureRect.new()
				#tairitsu.texture = icon_list[3]
				#tairitsu.z_index = 7
				#var wreath = TextureButton.new()
				#wreath.modulate = Color(1,1,1,0)
				#wreath.z_index = 7
func _on_iconwreath_pressed() -> void:
	$CharSelectAnimation.play("CHAR_SELECT_IN")
	
func _on_exit_pressed() -> void:
	$CharSelectAnimation.play("CHAR_SELECT_OUT")
