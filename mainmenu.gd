extends Control
@onready var scene = load("res://picture/mainmenu.jpg")
var move:float = -880
var velocity:float = 0
var is_roll_finished = false
@onready var background = $Menuscene

#信号
signal main_menu_start
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process_input(true)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_roll_finished:
		return 
	velocity = lerp(velocity,0.0,0.2)
	move += velocity * delta
	move = clamp(move,-880,-10)
	background.position.y = lerp(background.position.y,move,0.4)
func _input(event):
	
	if event is InputEventMouseButton && is_roll_finished:
		if event.button_index  == MOUSE_BUTTON_WHEEL_UP:
			velocity = -1700
		if  event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			velocity = 1700
			

func show_background():
	background.texture = scene
	background.z_index = 0
	background.expand_mode = TextureRect.EXPAND_KEEP_SIZE
	background.stretch_mode = TextureRect.STRETCH_SCALE 
	background.set_anchor(0,0,0,0)

	await get_tree().process_frame
	main_menu_start.emit()
	
	var roll_scene = create_tween()
	roll_scene.set_ease(Tween.EASE_IN_OUT)
	roll_scene.set_trans(Tween.TRANS_QUAD)
	
	roll_scene.tween_property(background,"position",Vector2(0,-880),2)
	await roll_scene.finished
	is_roll_finished = true
