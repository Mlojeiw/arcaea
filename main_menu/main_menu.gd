extends Control
@onready var role_list = [
	load("res://picture/role1.png"),
	load("res://picture/role2.png"),
]
@onready var background_shader = ShaderMaterial.new()

@onready var role = $Role
@onready var world = $World
@onready var background = $Background
@onready var start = $Start
@onready var setting = $Setting
@onready var story = $Story
@onready var course = $Course
var background_tween : Tween
var offset_vec = Vector2(80,0)# 80 80
var is_used = false
func _ready() -> void:
	background_shader.shader = preload("res://main_menu/background.gdshader")
	background_shader.set_shader_parameter("offset",Vector2.ZERO)
	world.mouse_entered.connect(fade_in.bind(world))
	world.mouse_exited.connect(fade_out.bind(world))
	start.mouse_entered.connect(fade_in.bind(start))
	start.mouse_exited.connect(fade_out.bind(start))
	story.mouse_entered.connect(fade_in.bind(story))
	story.mouse_exited.connect(fade_out.bind(story))
	course.mouse_entered.connect(fade_in.bind(course))
	course.mouse_exited.connect(fade_out.bind(course))
	#show_main_menu()
#func _process(delta: float) -> void:
	#pass
func show_main_menu():
	if is_used:
		return
	is_used = true
	show_main_menu_background()
	show_role()
	show_story()
	show_start()
	show_world()
	show_course()
func show_main_menu_background():
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background.modulate = Color(1,1,1,0.7)
	background.set_anchor(0,0,0,0)
	background.position = Vector2(0,-700)
	background.material = background_shader
	await get_tree().process_frame
	if background_tween:
		background_tween.kill()
	background_tween = create_tween()
	background_tween.set_trans(Tween.TRANS_LINEAR)
	background_tween.set_loops()
	background_tween.tween_property(background_shader,"shader_parameter/offset",Vector2(0,690),35)
	background_tween.tween_property(background_shader,"shader_parameter/offset",Vector2(0,-700),35)
	background_tween.tween_interval(5)
func show_start():
	start.anchor_left = 0
	start.anchor_top = 0
	start.position = Vector2(270,350) 
	start.modulate = Color(1,1,1,0.8)
	move_effect(start,start.position + offset_vec,0.2)
func show_story():
	story.anchor_left = 0
	story.anchor_top = 0
	story.modulate = Color(1,1,1,0.8)
	story.position = Vector2(190,500) 
	move_effect(story,story.position + offset_vec,0.3)
	
func show_world():
	world.anchor_left = 0
	world.anchor_top = 0
	world.modulate = Color(1,1,1,0.8)
	world.position = Vector2(710,370) + offset_vec
	move_effect(world,Vector2(780,450),0.4)
	
func show_role():
	role.mouse_filter = Control.MOUSE_FILTER_IGNORE
	role.texture = role_list[0]
	role.position = Vector2(800,0) 
	move_effect(role,Vector2(700,0),0.4)
func show_course():
	course.position = Vector2(110 ,650) 
	course.modulate = Color(1,1,1,0.8)
	move_effect(course,course.position + offset_vec,0.4)
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
