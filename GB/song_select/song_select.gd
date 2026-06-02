extends Control
@onready var charicon = $Top/CharIconContainer/icon
@onready var songcontainer = $SongContainer
@onready var songlist = $SongList
@onready var songicon = $SongContainer/ColorRect/TextureRect
@onready var score = $Top/ScoreTab/Label
@onready var difficultycontrol = $Top/DifficultyControl
@onready var charselect = $CharSelect
var jacket = {
	"Light":load("res://picture/song_select/song_jacket_back_light.png"),
	"Dark":load("res://picture/song_select/song_jacket_back_dark.png"),
}
var is_used = false
var songcard: Array[SongCard]
func _ready() -> void:	
	signal_connect()
	songlist.setup()
func show_song_select():
	if is_used:
		return
	is_used = true
	$SongContainerAnimation.play("SongContainer")
func reset():
	is_used = false
	charselect.reset()
	$SongContainerAnimation.play("RESET")
	var data = UserData.char_list[UserData.current_char_id]
	charicon.texture = data.icon[data.default]
func setup():
	$SongContainerAnimation.play("RESET")
	var data = UserData.char_list[UserData.current_char_id]
	charicon.texture = data.icon[data.default]
	for x in songlist.get_children():
		songcard.append(x)
		if x.id == UserData.song_id:
			songicon.texture = x.icon
			$SongContainer.texture_normal = jacket[x.color]
			if not UserData.difficulty in x.difficulty:
				score.text = x.diff_score[x.difficulty[0]]
func _on_song_switch(song:Song):
	songicon.texture = UserData.song_list[UserData.song_id].icon
	if UserData.difficulty in songcard[UserData.song_id].difficulty:
		score.text = songcard[UserData.song_id].diff_score[UserData.difficulty]
	else:
		UserData.set_difficulty(songcard[UserData.song_id].difficulty[0])
		score.text = song.diff_chart[UserData.difficulty].score
	_on_background_switch()	
	$SongContainerAnimation.play("SongContainer")
func _on_song_container_pressed() -> void:
	$SongContainerAnimation.play("SongContainer")
func _on_icon_pressed() -> void:
	for x:SongCard in songlist.get_children():
		x.body.mouse_filter = Control.MOUSE_FILTER_IGNORE
	charselect.anim_in()
	songlist.mouse_filter = MOUSE_FILTER_IGNORE
	songcontainer.mouse_filter = MOUSE_FILTER_IGNORE
func _on_exit_pressed() -> void:
	for x:SongCard in songlist.get_children():
		x.body.mouse_filter = Control.MOUSE_FILTER_STOP
	var char = UserData.char_list[UserData.current_char_id]
	charicon.texture = char.icon[char.default]
	songcontainer.mouse_filter  = MOUSE_FILTER_STOP
	charselect.visible = false
func _on_diff_switch():
	score.text = UserData.song_list[UserData.song_id].diff_chart[UserData.difficulty].score
func _on_background_switch():
	var tween = create_tween()
	tween.set_parallel(true)
	if songcard[UserData.song_id].color == "Dark":
		tween.tween_property($Light,"modulate",Color(1,1,1,0),0.2)
		tween.tween_property($Dark,"modulate",Color(1,1,1,1),0.2)
	if songcard[UserData.song_id].color == "Light":
		tween.tween_property($Light,"modulate",Color(1,1,1,1),0.2)
		tween.tween_property($Dark,"modulate",Color(1,1,1,0),0.2)
func signal_connect():
	charselect.exit.connect(_on_exit_pressed)
	songlist.set_finished.connect(setup)
	UserData.song_switch.connect(_on_song_switch)
	UserData.difficulty_switch.connect(_on_diff_switch)
