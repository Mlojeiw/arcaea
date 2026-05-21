extends Control
@onready var background_scene = load("res://picture/mainmenu/layout/bg_core.jpg")
@onready var start_scene = load("res://picture/mainmenu/layout/main_musicplay.png")
@onready var course_scene = load("res://picture/mainmenu/layout/main_course.png")
@onready var story_scene = load("res://picture/mainmenu/layout/main_story.png")
@onready var world_scene = load("res://picture/mainmenu/mainmenuWorld.png")
@onready var world_text = load("res://picture/mainmenu/world_text.png")

@onready var role_list = [
	load("res://picture/role1.png"),
	load("res://picture/role2.png"),
]

@onready var role = $Role
@onready var world = $World
@onready var background = $Background
@onready var start = $Start
@onready var setting = $Setting
@onready var story = $Story
@onready var course = $Course
var offset_vec = Vector2(80,80)
func _ready() -> void:
	pass
func _process(delta: float) -> void:
	pass
func show_main_menu():
	show_main_menu_background()
	show_role()
	show_story()
	show_start()
	show_world()
	show_course()
func show_main_menu_background():
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background.texture = background_scene
	background.expand_mode = TextureRect.EXPAND_KEEP_SIZE
	background.stretch_mode = TextureRect.STRETCH_SCALE
	background.modulate = Color(1,1,1,0.7)
	background.z_index = 0
	background.set_anchor(0,0,0,0)
	background.position = Vector2(0,-700)
	await get_tree().process_frame
	var tween = create_tween() 
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_loops()
	tween.tween_property(background,"position",Vector2(0,-10),30)
	tween.tween_property(background,"position",Vector2(0,-700),30)
	tween.tween_interval(5)
func show_start():
	start.anchor_left = 0
	start.anchor_top = 0
	start.position = Vector2(430 ,430 ) - offset_vec
	start.z_index = 2
	start.modulate = Color(1,1,1,0.8)
	start.texture_normal = 	start_scene
	start.texture_hover = start_scene
	start.mouse_entered.connect(fade_in.bind(start))
	start.mouse_exited.connect(fade_out.bind(start))
	
func show_story():
	
	story.anchor_left = 0
	story.anchor_top = 0
	story.z_index = 2
	story.modulate = Color(1,1,1,0.8)
	story.position = Vector2(350 ,580 ) - offset_vec
	story.texture_normal = story_scene
	story.texture_hover = story_scene
	story.mouse_entered.connect(fade_in.bind(story))
	story.mouse_exited.connect(fade_out.bind(story))
	
func show_world():
	world.anchor_left = 0
	world.anchor_top = 0
	world.z_index = 2
	world.scale = Vector2(0.75,0.75)
	
	world.modulate = Color(1,1,1,0.8)
	world.texture_normal = world_scene
	world.texture_hover = world_scene
	world.position = Vector2(820 ,450 ) - offset_vec
	world.pivot_offset = world.size / 2
	world.mouse_entered.connect(fade_in.bind(world))
	world.mouse_exited.connect(fade_out.bind(world))

func show_role():
	role.mouse_filter = Control.MOUSE_FILTER_IGNORE
	role.texture = role_list[0]
	role.z_index = 1
	role.scale = Vector2(0.7,0.7)
	role.position = Vector2(850,100)
func show_course():
	course.z_index = 2
	course.position = Vector2(270 ,730 ) - offset_vec
	course.modulate = Color(1,1,1,0.8)
	course.texture_normal = course_scene
	course.texture_hover = course_scene
	course.mouse_entered.connect(fade_in.bind(course))
	course.mouse_exited.connect(fade_out.bind(course))
func fade_in(node:TextureButton):
	var tween =create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(node,"modulate",Color(1,1,1,1),0.5)
func fade_out(node:TextureButton):
	var tween =create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(node,"modulate",Color(1,1,1,0.8),0.5)

	
