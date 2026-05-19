extends Node2D
var is_finished = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HUD.ui_scene_finished.connect(_on_ui_scene_finished)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_start") && ! $Animationtransition.was_used && is_finished :
		$Animationtransition.show_scene()
		$HUD/AudioStreamPlayer2D.stop()
		is_finished = false
func _on_ui_scene_finished():
	is_finished = true
