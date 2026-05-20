extends Node2D

var ui_finished = false
var is_transition_music_play 
#信号
signal hud_scene_end
#资源
@onready var  MAIN_MENU_MUSIC = preload("res://music/Arcaea_Team - Menu BGM v3.0.mp3")
@onready var TRANSITION_MUSIC = preload("res://music/transition.mp3")
@onready var HUD_MUSIC = [
		preload("res://music/arcaea v2.20.mp3"),
		preload("res://music/Arcaea_Team - Epilogue.mp3"),
		preload("res://music/Arcaea_Team - Finale Start.mp3")
	] 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HUD.ui_scene_finished.connect(_on_ui_scene_finished)
	$Animationtransition.transition_start.connect(_transition_music)
	hud_scene_end.connect(_current_music_end)
	
	$HUD.hud_scene_start.connect(_hud_music)
	$Animationtransition.switch_hud_main_menu_scene.connect(_switch_hud_mainmenu_scene)
	$Mainmenu.main_menu_start.connect(_main_menu_music)
	$Mainmenu.visible = false
	$HUD.visible = true
	$HUD.show_hud_scene()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_start") && ! $Animationtransition.was_used && ui_finished :
		hud_scene_end.emit()
		show_transition()
		ui_finished = false

#控制转场
func _on_ui_scene_finished():
	ui_finished = true
func _switch_hud_mainmenu_scene():
	$HUD.visible = false
	$Mainmenu.visible = true
	$Mainmenu.show_background()
func _current_music_end():
	$Musicplayer.stop()
func _hud_music():
	$Musicplayer.stream = HUD_MUSIC[0]
	$Musicplayer.play()
func _main_menu_music():
	if is_transition_music_play :
		await get_tree().create_timer(0.17).timeout
		$Musicplayer.stream = MAIN_MENU_MUSIC
		$Musicplayer.play()
		return 
	$Musicplayer.stream = MAIN_MENU_MUSIC
	$Musicplayer.play()
	
func _transition_music():
	is_transition_music_play = true
	$Musicplayer.stream = TRANSITION_MUSIC
	$Musicplayer.play()
	await $Musicplayer.finished
	is_transition_music_play = false
func show_transition():
	
	$Animationtransition.show_scene()
