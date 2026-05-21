extends Node2D
var dir = {
	"HUD" : hud_start,
	"MainMenu" : main_menu_start,
	"LevelMenu" : level_menu_music,
}
var current_scene:Control
var traget_scene:Control
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
func _ready() -> void:
	current_scene = $HUD
	$HUD.hud_scene_start.connect(hud_start)
	$HUD.ui_scene_finished.connect(_on_ui_scene_finished)
	$AnimationTransition.shutter_close.connect(shutter_close_music)
	$AnimationTransition.shutter_open.connect(shutter_open_music)
	$HUD.visible = true
	$HUD.show_hud_scene()
	

func _process(delta: float) -> void:
	pass

func _input(event):
	if event is InputEventMouseButton && hud_ui_finished:
		if event.pressed && $HUD.visible && !$AnimationTransition.was_used:
			traget_scene = $MainMenu
			switch_to(traget_scene)
#控制转场

func switch_to(traget:Control):
	if $AnimationTransition.was_used:
		return
	var traget_name = traget.name
	$AnimationTransition.show_transition(0.9)
	await $AnimationTransition.switch_scene
	current_scene.visible = false
	current_scene = traget
	
	current_scene.visible = true
	
	play_scene(traget_name)
	
func play_scene(traget:String):
	dir[traget].call()

func hud_start():
	hud_music()

func _on_ui_scene_finished():
	hud_ui_finished = true

func main_menu_start():
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
func main_menu_music():
	$MusicPlayer.stop()
	$MusicPlayer.stream = MAIN_MENU_MUSIC
	$MusicPlayer.play()

func hud_music():
	$MusicPlayer.stop()
	$MusicPlayer.stream = HUD_MUSIC[0]
	$MusicPlayer.play()
