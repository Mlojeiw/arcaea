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
@onready var charselect = $CharSelect
var background_tween : Tween
var is_used = false
var is_anim = false
signal music_start
func _ready() -> void:
	singal_connect()
	setup()

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
	charselect.reset()
	$MenuAnimation.play("RESET")
func reflesh_main_menu():
	var data = UserData.char_list[UserData.current_char_id]
	role.texture = data.texture[data.default]
	charicon.texture = data.icon[data.default]
	$MenuAnimation.play("ROLE")
func setup():
	var data = UserData.char_list[UserData.current_char_id]
	role.texture = data.texture[data.default]
	charicon.texture = data.icon[data.default]
func _on_iconwreath_pressed() -> void:
	if is_anim:
		return
	is_anim = true
	charselect.anim_in()
func _on_exit_pressed() -> void:
	is_anim = false
	charselect.anim_out()
	reflesh_main_menu()
#anim
func fade_in(node:TextureButton):
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(node,"modulate",Color(1,1,1,1),0.5)
func fade_out(node:TextureButton):
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(node,"modulate",Color(1,1,1,0.8),0.5)
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
	charselect.exit.connect(_on_exit_pressed)
	
