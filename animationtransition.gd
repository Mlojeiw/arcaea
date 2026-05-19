extends Control
@onready var scene_list = [
	load("res://picture/p11.png"),
	load("res://picture/p12.png"),
]
@onready var transition_music = load("res://music/transition.mp3")
var was_used:bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func show_scene():
	var pos_y = -245
	var left_scene = TextureRect.new()
	var right_scene = TextureRect.new()
	left_scene.texture = scene_list[0]
	right_scene.texture = scene_list[1]
	left_scene.scale = Vector2(1.6,1.6)
	right_scene.scale = Vector2(1.6,1.6)
	left_scene.z_index = 10
	right_scene.z_index = 10
	
	left_scene.modulate = Color(1,1,1,1)
	right_scene.modulate = Color(1,1,1,1)
	left_scene.position = Vector2(-2500,pos_y)
	right_scene.position = Vector2(2070,pos_y)
	add_child(right_scene)
	add_child(left_scene)
	$AudioStreamPlayer2D.stream = transition_music
	$AudioStreamPlayer2D.play()
	var enter = create_tween()
	enter.set_ease(Tween.EASE_IN_OUT)
	enter.set_trans(Tween.TRANS_QUAD)
	enter.set_parallel(true)
	
	enter.tween_property(left_scene,"position",Vector2(-105,pos_y),0.5)
	enter.tween_property(right_scene,"position",Vector2(1260,pos_y),0.5)
	await enter.finished
	await get_tree().create_timer(0.9).timeout
	var end = create_tween()
	end.set_ease(Tween.EASE_IN_OUT)
	end.set_trans(Tween.TRANS_LINEAR)
	end.set_parallel(true)
	end.tween_property(left_scene,"position",Vector2(-2500,pos_y),0.5)
	end.tween_property(right_scene,"position",Vector2(2070,pos_y),0.5)
	
	was_used = true
	await end.finished
	left_scene.queue_free()
	right_scene.queue_free()
