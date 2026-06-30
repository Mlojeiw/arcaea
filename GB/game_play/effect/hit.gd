extends AnimatedSprite2D

func _ready():
	visible = false
	animation_finished.connect(_on_animation_finished)

func _on_animation_finished():
	visible = false
	stop()
