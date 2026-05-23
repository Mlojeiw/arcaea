extends Control
@onready var scene = load("res://picture/levelmenubackground.jpg")
var move:float = -880
var move_velocity:float = 0
var is_roll_finished = false
var last_mouse:Vector2
var last_pos: Vector2
var last_time 
var drag_velocity:Vector2
var is_dragging :bool
@onready var background = $Menuscene

@onready var is_used :bool = false
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_roll_finished :
		return 
	move += move_velocity * delta
	
	if !is_dragging:
		move_velocity = lerp(move_velocity,0.0,0.05)
	move = clamp(move,-880,-10)
		
	background.position.y = lerp(background.position.y,move,0.09)
func _input(event):
	
	if event is InputEventMouseButton && is_roll_finished && !is_dragging:
		if event.button_index  == MOUSE_BUTTON_WHEEL_UP:
			move_velocity = -1700
		if  event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			move_velocity = 1700
	if event is InputEventMouseButton && is_roll_finished :
		if event.pressed:
			last_mouse = get_global_mouse_position()
			last_time = Time.get_ticks_msec() / 1000.0
			last_pos = background.position
			is_dragging = true
			drag_velocity = Vector2.ZERO
			
		else:
			is_dragging = false
			var now_time = Time.get_ticks_msec() / 1000.0
			var offest_time
			if last_time:
				offest_time = now_time - last_time
			if offest_time > 0 :
				drag_velocity = (background.position - last_pos)/offest_time
				if abs(drag_velocity.y) <200:
					drag_velocity.y = 800 if drag_velocity.y > 0 else -800 
				move_velocity = drag_velocity.y * 1.4
	if event is InputEventMouseMotion && is_dragging:
		var current_mouse = get_global_mouse_position()
		var current_time = Time.get_ticks_msec() / 1000.0
		var delta = current_mouse - last_mouse
		background.position += delta 
		background.position.y = clamp(background.position.y,-880,-10)
		background.position.x = 0  
		move = background.position.y  

		last_time = current_time
		last_mouse = current_mouse
		last_pos = background.position
func show_level_menu():
	is_used = true
	show_background()
func show_background():
	background.texture = scene
	background.z_index = 0
	background.expand_mode = TextureRect.EXPAND_KEEP_SIZE
	background.stretch_mode = TextureRect.STRETCH_SCALE 
	background.set_anchor(0,0,0,0)

	await get_tree().process_frame
	
	var roll_scene = create_tween()
	roll_scene.set_ease(Tween.EASE_IN_OUT)
	roll_scene.set_trans(Tween.TRANS_QUAD)
	
	roll_scene.tween_property(background,"position",Vector2(0,-880),2)
	await roll_scene.finished
	is_roll_finished = true
	
