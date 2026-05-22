extends Control
@onready var INTERVAL = Vector2(0,150)
@onready var message_list = [
	load("res://picture/hud_message/m1_core.png"),
	load("res://picture/hud_message/m2_core.png"),
	load("res://picture/hud_message/m3_core.png"),
]
@onready var glass = load("res://picture/hud/glass.png")
@onready var title_scene = load("res://picture/hud/title.png")
@onready var title_grow_scene = load("res://picture/hud/title_grow.png")
@onready var is_used = false
var picture_position = Vector2(600,200)
var container_title_position = Vector2(300,560) + Vector2(0,-150)
var ui_roll_end = false
var title_effect:Tween
@onready var char_t = ShaderMaterial.new()
@onready var char_h = ShaderMaterial.new()

@onready var hikari = $Hikari
@onready var tairitsu = $Tairitsu
@onready var background = $Background
@onready var container_title = $Title
@onready var title = $Title/title
@onready var title_grow = $Title/title_grow
func _ready() -> void:
	char_t.shader = preload("res://hud/char_t_offset.gdshader")
	char_h.shader = preload("res://hud/char_h_offset.gdshader")
	hikari.material = char_h
	tairitsu.material = char_t
	char_h.set_shader_parameter("offset",Vector2.ZERO)
	char_t.set_shader_parameter("offset",Vector2.ZERO)
	set_anchors_preset(Control.PRESET_FULL_RECT)
func _process(delta: float) -> void:
	pass

#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton:
		#if event.double_click && !ui_roll_end:
			
			
func show_hud_scene():
	is_used = true
	show_ui_scene()
	show_message(message_list[0],2,6,picture_position,Vector2(0,60),1,1,Vector2(1,1))
	show_message(message_list[1],4,4,picture_position,Vector2(0,60),1,1,Vector2(1,1))
	show_message(message_list[2],6,2,picture_position,Vector2(0,60),1,1,Vector2(1,1))
	show_title(9,Vector2(300,560),5)
	show_hikari(15,Vector2(600,230),Vector2(0,-10),Vector2(590,230),0.1)
	show_tairitsu(15,Vector2(300,100),Vector2(0,10),Vector2(310,100),0.1)
	show_glass(glass,15,Vector2(120,-80),0.1,3,Vector2(1.217,1.217),Vector2(1.28,1.28))
	show_flash(15)
func show_message(texture,delay,stay_time,pos,offset_pos,duration,z_ind,sca):
	picture_position += INTERVAL
	if delay > 0:
		await get_tree().create_timer(delay).timeout
	var picture = TextureRect.new()
	picture.texture = texture 
	picture.modulate = Color(1,1,1,0)
	picture.position = pos + offset_pos
	picture.scale = sca
	picture.z_index = z_ind
	add_child(picture)
	fade_in(picture,pos,duration)
	await get_tree().create_timer(stay_time).timeout

	await fade_out(picture,duration)
	picture.queue_free()
func show_title(delay,pos,duration):
	if delay > 0:
		await get_tree().create_timer(delay).timeout

	container_title.position = container_title_position
	title.position = Vector2(140,100)
	title.modulate = Color(1,1,1,0)
	await get_tree().process_frame
	title.pivot_offset = title.size / 2
	title_grow.position = Vector2(140,100)
	title_grow.modulate = Color(1,1,1,0)
	await get_tree().process_frame
	title_grow.pivot_offset = title_grow.size /2 
	var fade_in = create_tween()
	fade_in.set_ease(Tween.EASE_IN_OUT)
	fade_in.set_trans(Tween.TRANS_SINE)
	fade_in.set_parallel(true)
	fade_in.tween_property(container_title,"position",pos,duration)
	fade_in.tween_property(title,"modulate",Color(1,1,1,1),duration)
	await fade_in.finished
	await get_tree().create_timer(2).timeout
	if title_effect:
		title_effect.kill()
	title_effect = create_tween()
	title_effect.set_ease(Tween.EASE_IN_OUT)
	title_effect.set_trans(Tween.TRANS_LINEAR)
	title_effect.set_loops()
	title_effect.tween_property(title_grow,"modulate",Color(1,1,1,0.6),1.0)
	title_effect.tween_property(title_grow,"modulate",Color(1,1,1,0),1.0)
	title_effect.tween_property(title_grow,"scale",Vector2(3,1.8),1.0)
	title_effect.tween_property(title_grow,"scale",Vector2(1.31,1.31),1.0)
func show_glass(texture,delay,pos,duration,z_ind,current_scale,new_scale):
	if delay > 0:
		await get_tree().create_timer(delay).timeout
	var container = Node2D.new()
	container.position = pos
	container.name = "glass"
	add_child(container)
	var picture = TextureRect.new()
	picture.texture = texture
	picture.position = pos 
	picture.modulate = Color(1,1,1,0)
	picture.z_index = z_ind
	picture.scale = current_scale
	picture.pivot_offset = Vector2(texture.get_width() / 2, texture.get_height() / 2)
	container.add_child(picture)
	fade_in(picture,picture.position,duration)
	var move_affect = create_tween().bind_node(container)
	move_affect.set_trans(Tween.TRANS_LINEAR)
	move_affect.set_loops()
	move_affect.tween_property(picture,"scale",new_scale,2.0)
	move_affect.tween_property(picture,"scale",current_scale,2.0)
func show_ui_scene():
	background.set_anchor(0,0,0,0)
	await get_tree().process_frame
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(background, "position:y", -600, 15.0)
	await tween.finished
	ui_roll_end = true
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
	await tween.finished
	flash.queue_free()
func show_hikari(delay,pos,move_position,enter_pos,duration):
	hikari.modulate = Color(1,1,1,0)
	hikari.position = enter_pos
	if delay > 0:
		await get_tree().create_timer(delay).timeout
	fade_in(hikari,pos,duration)
	var up_pos = + move_position
	var down_pos = - move_position
	var move_affect = create_tween()
	move_affect.set_trans(Tween.TRANS_LINEAR)
	move_affect.set_loops()
	move_affect.tween_property(hikari.material,"shader_parameter/offset",up_pos,2)
	move_affect.tween_property(hikari.material,"shader_parameter/offset",down_pos,2)
func show_tairitsu(delay,pos,move_position,enter_pos,duration):
	tairitsu.modulate = Color(1,1,1,0)
	tairitsu.position = enter_pos
	if delay > 0:
		await get_tree().create_timer(delay).timeout
	fade_in(tairitsu,pos,duration)
	var up_pos = + move_position
	var down_pos = - move_position
	var move_affect = create_tween()
	move_affect.set_trans(Tween.TRANS_LINEAR)
	move_affect.set_loops()
	move_affect.tween_property(tairitsu.material,"shader_parameter/offset",up_pos,2)
	move_affect.tween_property(tairitsu.material,"shader_parameter/offset",down_pos,2)
func fade_in(picture,pos,duration):
	var fade_in = create_tween()
	fade_in.set_ease(Tween.EASE_IN_OUT)
	fade_in.set_trans(Tween.TRANS_QUAD)
	fade_in.set_parallel(true)
	fade_in.tween_property(picture,"position",pos,duration)
	fade_in.tween_property(picture,"modulate",Color(1,1,1,1),duration)
	await fade_in.finished
func fade_out(picture,duration):
	var fade_out = create_tween()
	fade_out.set_ease(Tween.EASE_IN_OUT)
	fade_out.set_trans(Tween.TRANS_QUAD)
	fade_out.tween_property(picture,"modulate",Color(1,1,1,0),duration)
	await fade_out.finished
func reset():
	ui_roll_end = false
	background.position = Vector2.ZERO
	picture_position = Vector2(600,200)
	title_effect.kill()
	title_effect = null
	container_title.position = container_title_position
	title.modulate  = Color(1,1,1,0)
	title_grow.modulate  = Color(1,1,1,0)
	title.scale = Vector2(1.3,1.3)
	title_grow.scale = Vector2(1.32,1.32)
	var old_galss = get_node_or_null("glass")
	if old_galss:
		old_galss.queue_free()
