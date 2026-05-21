extends Control
@onready var INTERVAL = Vector2(0,150)
@onready var scene_list = [
	load("res://picture/hud_message/m1_core.png"),
	load("res://picture/hud_message/m2_core.png"),
	load("res://picture/hud_message/m3_core.png"),
	load("res://picture/hud/logo.png"),
	load("res://picture/hud/char_h.png"),
	load("res://picture/hud/char_t.png"),
	load("res://picture/hud/p9.png")
]
@onready var ui_scene = load("res://picture/hud/ui.jpg")

var picture_position = Vector2(600,200)
signal ui_scene_finished
signal hud_scene_start

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
func _process(delta: float) -> void:
	pass

func show_hud_scene():
	hud_scene_start.emit()
	
	show_ui_scene(ui_scene)
	show_picture(scene_list[0],2,6,picture_position,Vector2(0,60),1,1,Vector2(1,1))
	picture_position += INTERVAL
	show_picture(scene_list[1],4,4,picture_position,Vector2(0,60),1,1,Vector2(1,1))
	picture_position += INTERVAL
	show_picture(scene_list[2],6,2,picture_position,Vector2(0,60),1,1,Vector2(1,1))
	show_logo(scene_list[3],9,Vector2(300,560),Vector2(0,-150),5,3,Vector2(1.3,1.3))
	show_role(scene_list[4],15,Vector2(600,230),Vector2(0,-10),Vector2(590,230),0.1,2,Vector2(0.6,0.6))
	show_role(scene_list[5],15,Vector2(300,100),Vector2(0,10),Vector2(310,100),0.2,1,Vector2(0.6,0.6))
	
	show_decolation(scene_list[6],15,Vector2(100,-80),0.1,3,Vector2(1.217,1.217),Vector2(1.28,1.28))
	
	show_flash(15)
	
	
	
func show_picture(texture,delay,stay_time,pos,offest_pos,duration,z_ind,sca):
	if delay > 0:
		await get_tree().create_timer(delay).timeout
	var picture = TextureRect.new()
	picture.texture = texture 
	picture.modulate = Color(1,1,1,0)
	picture.position = pos + offest_pos
	picture.scale = sca
	picture.z_index = z_ind
	add_child(picture)
	var fade_in = create_tween()
	fade_in.set_ease(Tween.EASE_IN_OUT)
	fade_in.set_trans(Tween.TRANS_QUAD)
	fade_in.set_parallel(true)
	fade_in.tween_property(picture,"position",pos,duration)
	
	fade_in.tween_property(picture,"modulate",Color(1,1,1,1),duration)
	
	await get_tree().create_timer(stay_time).timeout
	var fade_out = create_tween()
	fade_out.set_ease(Tween.EASE_IN_OUT)
	fade_out.set_trans(Tween.TRANS_QUAD)
	fade_out.tween_property(picture,"modulate",Color(1,1,1,0),duration)
	await fade_out.finished
	picture.queue_free()

func show_logo(texture,delay,pos,offest_pos,duration,z_ind,sca):
	if delay > 0:
		await get_tree().create_timer(delay).timeout
	var logo = TextureRect.new()
	logo.texture = texture
	logo.position = pos + offest_pos
	logo.z_index = z_ind
	logo.scale = sca
	logo.modulate = Color(1,1,1,0)
	add_child(logo)
	var fade_in = create_tween()
	fade_in.set_ease(Tween.EASE_IN_OUT)
	fade_in.set_trans(Tween.TRANS_SINE)
	fade_in.set_parallel(true)
	fade_in.tween_property(logo,"position",pos,duration)
	fade_in.tween_property(logo,"modulate",Color(1,1,1,1),duration)
	await fade_in.finished

	var move_affect = create_tween()
	move_affect.set_ease(Tween.EASE_IN_OUT)
	move_affect.set_trans(Tween.TRANS_LINEAR)
	move_affect.set_loops()
	move_affect.tween_property(logo,"modulate",Color(1,1,1,0.7),2.0)
	move_affect.tween_property(logo,"modulate",Color(1,1,1,1),2.0)
		
func show_decolation(texture,delay,pos,duration,z_ind,current_scale,new_scale):
	if delay > 0:
		await get_tree().create_timer(delay).timeout

	var container = Node2D.new()
	container.position = pos
	add_child(container)
	var picture = TextureRect.new()
	picture.texture = texture
	picture.position = pos 
	picture.modulate = Color(1,1,1,0)
	picture.z_index = z_ind
	picture.scale = current_scale
	picture.pivot_offset = Vector2(texture.get_width() / 2, texture.get_height() / 2)
	container.add_child(picture)
	var fade_in = create_tween()
	fade_in.set_ease(Tween.EASE_IN_OUT)
	fade_in.set_trans(Tween.TRANS_QUAD)
	fade_in.tween_property(picture,"modulate",Color(1,1,1,1),duration)
	await fade_in.finished
	
	var move_affect = create_tween()
	move_affect.set_ease(Tween.EASE_IN_OUT)
	move_affect.set_trans(Tween.TRANS_QUAD)
	move_affect.set_loops()
	move_affect.tween_property(picture,"scale",new_scale,1.0)
	move_affect.tween_property(picture,"scale",current_scale,1.0)
	
func show_ui_scene(scene):
	var background = $Background
	background.texture = scene
	background.expand_mode = TextureRect.EXPAND_KEEP_SIZE
	background.stretch_mode = TextureRect.STRETCH_SCALE
	background.z_index = 0
	background.set_anchor(0,0,0,0)
	await get_tree().process_frame
	var tween = create_tween()
	#tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(background, "position:y", -600, 15.0)
	await tween.finished
	ui_scene_finished.emit()
func show_role(texture,delay,pos,move_position,enter_pos,duration,z_ind,sca):
	if delay > 0:
		await get_tree().create_timer(delay).timeout
	var picture = TextureRect.new()
	picture.texture =texture
	picture.modulate = Color(1,1,1,0)
	picture.position = enter_pos
	picture.scale =sca
	picture.z_index = z_ind
	add_child(picture)
	var fade_in = create_tween()
	fade_in.set_trans(Tween.TRANS_SINE)
	fade_in.set_parallel(true)
	fade_in.tween_property(picture,"modulate",Color(1,1,1,1),duration)
	fade_in.tween_property(picture,"position",pos,duration)
	
	await fade_in.finished 
	var up_pos = pos + move_position
	var down_pos = pos - move_position
	var move_affect = create_tween()
	move_affect.set_trans(Tween.TRANS_LINEAR)
	move_affect.set_speed_scale(0.9)
	
	move_affect.set_loops()
	move_affect.tween_property(picture,"position",up_pos,1)
	move_affect.tween_property(picture,"position",down_pos,1)
func show_flash(delay):
	if delay > 0 :
		await get_tree().create_timer(delay).timeout
	var flash = ColorRect.new()
	flash.color = Color.WHITE
	flash.anchor_bottom = 1
	flash.anchor_right = 1
	flash.modulate = Color(1,1,1,0)
	flash.z_index = 10
	flash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(flash)
	var tween = create_tween()
	tween.tween_property(flash,"modulate",Color(1,1,1,1),0.2)
	tween.tween_property(flash,"modulate",Color(1,1,1,0),0.1)
	
