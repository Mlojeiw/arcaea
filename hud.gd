extends Control
@onready var INTERVAL = Vector2(0,150)
@onready var scene_list = [
	load("res://picture/p1.png"),
	load("res://picture/p2.png"),
	load("res://picture/p3.png"),
	load("res://picture/p4.png"),
	load("res://picture/p5.png"),
	load("res://picture/p6.png"),
	load("res://picture/p7.png"),
	load("res://picture/p8.png"),
	load("res://picture/p9.png"),
	load("res://picture/p10.png"),
	
]
@onready var ui_scene = load("res://picture/ui.jpg")
@onready var bgm_list = [
		preload("res://music/arcaea v2.20.mp3"),
		preload("res://music/Arcaea_Team - Epilogue.mp3"),
		preload("res://music/Arcaea_Team - Finale Start.mp3")
	]
var picture_position = Vector2(600,200)
signal ui_scene_finished
func select_music():
	var new_music = randi_range(0,0)
	$AudioStreamPlayer2D.stream = bgm_list[new_music]
	$AudioStreamPlayer2D.play()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	$Gamestart.pressed.connect(_on_game_start)
	select_music()
	show_hud_scene()
	$AudioStreamPlayer2D.finished.connect(_on_music_finished)
func _process(delta: float) -> void:
	pass
func _on_music_finished():
	select_music()
func _on_game_start():
	if $AudioStreamPlayer2D.finished.is_connected(_on_music_finished):
		$AudioStreamPlayer2D.finished.disconnect(_on_music_finished)
	$AudioStreamPlayer2D.stop()
func load_picture(picture: TextureRect,texture,picture_modulate,pos,picture_scale,picture_z_index):
	picture.texture = texture
	picture.modulate = picture_modulate
	picture.position = picture_position
	picture.scale = picture_scale
	picture.z_index = picture_z_index
func show_hud_scene():
	show_ui_scene(ui_scene)
	show_picture(scene_list[0],2,6,picture_position,Vector2(0,60),1,1,Vector2(1,1))
	picture_position += INTERVAL
	show_picture(scene_list[1],4,4,picture_position,Vector2(0,60),1,1,Vector2(1,1))
	picture_position += INTERVAL
	show_picture(scene_list[2],6,2,picture_position,Vector2(0,60),1,1,Vector2(1,1))
	show_logo(scene_list[3],9,Vector2(300,560),Vector2(0,-150),5,3,Vector2(1.3,1.3))
	show_role(scene_list[6],15,Vector2(620,220),Vector2(0,-10),Vector2(610,220),0.1,2,Vector2(1,1))
	show_role(scene_list[7],15,Vector2(0,100),Vector2(0,10),Vector2(10,100),0.1,1,Vector2(1.2,1.2))
	show_decolation(scene_list[8],15,Vector2(100,0),0.1,3,Vector2(1.217,1.27),Vector2(1.28,1.28))
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
	move_affect.tween_property(logo,"modulate",Color(1,1,1,0.8),2.0)
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
	fade_in.set_trans(Tween.TRANS_LINEAR)
	fade_in.set_parallel(true)
	fade_in.tween_property(picture,"modulate",Color(1,1,1,1),duration)
	fade_in.tween_property(picture,"position",pos,duration)
	
	await fade_in.finished 
	var up_pos = pos + move_position
	var down_pos = pos - move_position
	var move_affect = create_tween()
	move_affect.set_trans(Tween.TRANS_LINEAR)
	
	move_affect.set_loops()
	
	move_affect.tween_property(picture,"position",up_pos,1.0)
	move_affect.tween_property(picture,"position",down_pos,1.0)
func show_flash(delay):
	if delay > 0 :
		await get_tree().create_timer(delay).timeout
	var flash = ColorRect.new()
	flash.color = Color.WHITE
	flash.anchor_bottom = 1
	flash.anchor_right = 1
	flash.size = Vector2.ZERO
	flash.modulate = Color(1,1,1,0)
	flash.z_index = 10
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(flash)
	var tween = create_tween()
	tween.tween_property(flash,"modulate",Color(1,1,1,1),0.2)
	tween.tween_property(flash,"modulate",Color(1,1,1,0),0.1)
	
