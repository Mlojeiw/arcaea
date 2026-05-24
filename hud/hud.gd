extends Control
var is_used = false
var ui_roll_end = false
var is_skip = false
var role_move_pos = Vector2(0,10)
var hikari_move_effect:Tween
var tairitsu_move_effect:Tween
var glass_grow_move_effect:Tween
var glass_move_effect:Tween
signal music_skip(pos:float)
signal music_start
@onready var char_t = ShaderMaterial.new()
@onready var char_h = ShaderMaterial.new()
@onready var hikari = $Hikari
@onready var tairitsu = $Tairitsu
@onready var background = $Background
@onready var container_title = $Title
@onready var title = $Title/title
@onready var title_grow = $Title/title_grow
@onready var container_glass = $GlassContainer
@onready var glass = $GlassContainer/glass
@onready var glass_grow = $GlassContainer/glass_grow
@onready var message1 = $Message1
@onready var message2 = $Message2
@onready var message3 = $Message3
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
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.double_click && ! ui_roll_end && !is_skip && is_used:
			is_skip = true
			music_skip.emit(15.0)
			await skip_to_end()
func show_hud_scene():
	$StartAnimation.play("START")
	await  $StartAnimation.animation_finished
	$StartAnimation.play("FADE_IN")
	await $StartAnimation.animation_finished
	is_used = true
	
	
	music_start.emit()
	$BackgroundAnimation.play("background")
	$MessageInput.play("message")
	$TitleAnimation.play("title")
	$HikariAnimation.play("hikari")
	$TairitsuAnimation.play("tairitsu")
	$FlashAnimation.play("flash")
	$GlassAnimation.play("glass")

func background_roll_finished(anim_name:StringName):
	if anim_name == "background":
		ui_roll_end = true
func _hikari_move_effect(anim_name:StringName):
	if anim_name != "hikari":
		return
	var up_pos = + role_move_pos
	var down_pos = - role_move_pos
	hikari_move_effect = create_tween()
	hikari_move_effect.set_trans(Tween.TRANS_LINEAR)
	hikari_move_effect.set_loops()
	hikari_move_effect.tween_property(hikari.material,"shader_parameter/offset",up_pos,2)
	hikari_move_effect.tween_property(hikari.material,"shader_parameter/offset",down_pos,2)
func _tairitsu_move_effect(anim_name:StringName):
	if anim_name != "tairitsu":
		return
	var up_pos = - role_move_pos
	var down_pos = + role_move_pos
	tairitsu_move_effect = create_tween()
	tairitsu_move_effect.set_trans(Tween.TRANS_LINEAR)
	tairitsu_move_effect.set_loops()
	tairitsu_move_effect.tween_property(tairitsu.material,"shader_parameter/offset",up_pos,2)
	tairitsu_move_effect.tween_property(tairitsu.material,"shader_parameter/offset",down_pos,2)
func _glass_move_effect(anim_name:StringName):
	if anim_name != "glass":
		return
	glass_move_effect = create_tween()
	glass_move_effect.set_ease(Tween.EASE_IN_OUT)
	glass_move_effect.set_trans(Tween.TRANS_SINE)
	glass_move_effect.set_loops()
	glass_move_effect.tween_property(glass,"scale",Vector2(1.34,1.34),1)
	glass_move_effect.tween_property(glass,"scale",Vector2(1.3,1.3),1)
	glass_grow_move_effect = create_tween()
	glass_grow_move_effect.set_ease(Tween.EASE_IN_OUT)
	glass_grow_move_effect.set_trans(Tween.TRANS_SINE)
	glass_grow_move_effect.set_loops()
	glass_grow_move_effect.tween_property(glass_grow,"scale",Vector2(1.4,1.4),1)
	glass_grow_move_effect.tween_property(glass_grow,"scale",Vector2(1.34,1.34),1)
func skip_to_end():
	message1.modulate = Color(1,1,1,0)
	message2.modulate = Color(1,1,1,0)
	message3.modulate = Color(1,1,1,0)

	$BackgroundAnimation.seek(15.0)
	$TitleAnimation.seek(14.9)
	$HikariAnimation.seek(15.0)
	$TairitsuAnimation.seek(15.0)
	$FlashAnimation.seek(14.9)
	$GlassAnimation.seek(14.9)
	$MessageInput.seek(8)
	await get_tree().create_timer(1).timeout
	ui_roll_end = true
	is_skip = false

func reset():
	is_skip = false
	is_used = false
	ui_roll_end = false
	background.position = Vector2.ZERO
	hikari_move_effect.kill()
	hikari_move_effect = null
	tairitsu_move_effect.kill()
	tairitsu_move_effect = null
	glass_move_effect.kill()
	glass_move_effect = null
	$TitleAnimation.play("RESET")
	$BackgroundAnimation.play("RESET")
	$HikariAnimation.play("RESET")
	$TairitsuAnimation.play("RESET")
	$FlashAnimation.play("RESET")
	$GlassAnimation.play("RESET")
	$MessageInput.play("RESET")
	$StartAnimation.play("RESET")
