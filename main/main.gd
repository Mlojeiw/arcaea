extends Node2D
@onready var dir = {
	"HUD" : hud_start,
	"MainMenu" : main_menu_start,
	"LevelMenu" : level_menu_start,
}
@onready var last_scene_dir = {
	"MainMenu" : $HUD,
	"LevelMenu" : $MainMenu,
}
var current_scene:Control

var hud_ui_finished = false
#信号
#资源
@onready var  LEVEL_MENU_MUSIC = preload("res://music/Arcaea_Team - World BGM v3.0.mp3")
@onready var SHUTTER_CLOSE_MUSIC = preload("res://music/shuttermusic/shutter_close.wav")
@onready var SHUTTER_OPEN_MUSIC = preload("res://music/shuttermusic/shutter_open.wav")
@onready var HUD_MUSIC = [
		preload("res://music/Arcaea_Team - Arcaea v2.2.0 Title(intro+loop).mp3"),
		preload("res://music/Arcaea_Team - Epilogue.mp3"),
		preload("res://music/Arcaea_Team - Finale Start.mp3")
	] 
@onready var MAIN_MENU_MUSIC = preload("res://music/Arcaea_Team - Menu BGM v3.0.mp3")
@onready var ITEM_CLICK = preload("res://music/item_click.wav")
@onready var ITEM_CANCEL = preload("res://music/item_cancel.wav")
func _ready() -> void:
	current_scene = $HUD
	$MainMenu.visible = false
	$LevelMenu.visible = false
	signal_connect()
	hud_start()

func _process(delta: float) -> void:
	pass

func _input(event):
	if event is InputEventMouseButton && $HUD.ui_roll_end && !$HUD.is_skip :
		if event.pressed && $HUD.visible && !$AnimationTransition.was_used:
			switch_to($MainMenu)
	if Input.is_action_just_pressed("ui_esc") && !$HUD.visible:
		
			switch_to(last_scene_dir[current_scene.name])
		
#控制转场
func switch_to(traget:Control):
	if $AnimationTransition.was_used :
		return
	var traget_name = traget.name
	$AnimationTransition.show_transition(0.9)
	await $AnimationTransition.switch_scene
	current_scene.visible = false
	current_scene = traget
	current_scene.visible = true
	dir[traget.name].call()
	
func hud_start():
	if $HUD.is_used:
		$HUD.reset()	
	$HUD.show_hud_scene()
func level_menu_start():
	if !$LevelMenu.is_used:
		$LevelMenu.show_level_menu()
	level_menu_music()
func main_menu_start():
	if $MainMenu.is_used:
		$MainMenu.reset()
	$MainMenu.show_main_menu()

	main_menu_music()
func level_menu_music():
	$MusicPlayer.stop()
	$MusicPlayer.stream = LEVEL_MENU_MUSIC
	$MusicPlayer.play()
func shutter_close_music():
	$MusicPlayer.stop()
	$SoundEffect.stream = SHUTTER_CLOSE_MUSIC
	$SoundEffect.play()
func shutter_open_music():
	$SoundEffect.stream = SHUTTER_OPEN_MUSIC
	$SoundEffect.play()
func _current_music_skip(pos: float) -> void:
	$MusicPlayer.seek(pos)
func hud_music() -> void:
	$MusicPlayer.stop()
	$MusicPlayer.stream = HUD_MUSIC[0]
	$MusicPlayer.play()
func main_menu_music() -> void:
	$MusicPlayer.stop()
	$MusicPlayer.stream = MAIN_MENU_MUSIC
	$MusicPlayer.play()
func item_click_music() -> void:
	$SoundEffect.stream = ITEM_CLICK
	$SoundEffect.play()
func item_cancel_music() ->void:
	$SoundEffect.stream = ITEM_CLICK
	$SoundEffect.play()
	
func signal_connect():
	$AnimationTransition.shutter_close.connect(shutter_close_music)
	$AnimationTransition.shutter_open.connect(shutter_open_music)
	$MainMenu/Menu/World.pressed.connect(switch_to.bind($LevelMenu))
	$MainMenu/Menu/Top/CharIconContainer/iconwreath.pressed.connect(item_click_music)
	$MainMenu/Menu/Top/Setting.pressed.connect(item_click_music)
	$MainMenu/CharSelect/Exit.pressed.connect(item_cancel_music)
	$MainMenu/CharSelect/LeftArrow.pressed.connect(item_click_music)
	$MainMenu/CharSelect/RightArrow.pressed.connect(item_cancel_music)
	$MainMenu/CharSelect/State.pressed.connect(item_click_music)
	
	
	
