extends PanelContainer

@onready var label = $Label
var padding = Vector2(-10,-30)  

func _ready():
	#label.anchor_left = 0.0
	#label.anchor_top = 0.0
	#label.anchor_right = 0.0
	#label.anchor_bottom = 0.0
	#label.offset_left = padding.x
	#label.offset_top = padding.y
	label.resized.connect(_update_size)
	_update_size()
func set_text(new_text: String):
	label.text = new_text
	label.reset_size()         
func _update_size():
	size = label.size + padding * 1.2
	label.position = padding
