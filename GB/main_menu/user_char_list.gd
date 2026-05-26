extends Control
var velocity :float
var move:float = position.y
var max_offset = 30.0 
var min_offset = -(size.y - 1080) if size.y > 1080 else 0.0
func _ready() -> void:
	size.y = UserData.char_list.size() * 204 + 100
	min_offset = -(size.y - 1080) if size.y > 1080 else 0.0
func _process(delta: float) -> void:
	move += velocity * delta
	velocity = lerp(velocity,0.0,0.3)
	if move > max_offset :
		move = lerp(move,max_offset,0.3)
	if move < min_offset :
		move = lerp(move,min_offset,0.3)
	position.y = lerp(position.y,move,0.3)
func _gui_input(event) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			velocity += 2000
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			velocity += -2000
