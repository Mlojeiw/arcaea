extends Control
@onready var charicon = $Top/CharIconContainer/icon
@onready var songcontainer = $SongContainer
@onready var songlist = $SongList/Panel/ScrollContainer
@onready var songicon = $SongContainer/ColorRect/TextureRect
@onready var score = $Top/ScoreTab/Label
@onready var difficultycontrol = $Top/DifficultyControl
@onready var charselect = $CharSelect
@onready var grade = $Top/ScoreTab/TextureRect
@onready var song_name = $Top/Information/Control/TextureRect/Label
@onready var song_author = $Top/Information/Label2
@onready var song_bpm = $Top/Information/Control2/Label3
var jacket = {
	"Light":load("res://picture/song_select/song_jacket_back_light.png"),
	"Dark":load("res://picture/song_select/song_jacket_back_dark.png"),
}
var is_used = false
var songcard: Array[SongCard]
signal set_finished
func _ready() -> void:	
	signal_connect()
	songlist.setup()
func show_song_select():
	if is_used:
		return
	is_used = true
	$SongContainerAnimation.play("SongContainer")
	call_deferred("emit_signal", "set_finished")
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
	for x:SongCard in $SongList/Panel/ScrollContainer/Control.get_children():
		songcard.append(x)
		if x.id == UserData.song_id:
			set_grade(x.s)
			set_infom(x.s)
			
			songicon.texture = x.icon
			$SongContainer.texture_normal = jacket[x.color]
			if not UserData.difficulty in x.difficulty:
				score.text = x.diff_score[x.difficulty[0]]
func _on_song_switch(song:Song):
	if UserData.difficulty in song.difficulty:
		var chart = song.diff_chart[UserData.difficulty] as ChartData
		grade.texture = chart.get_grade()
	else:
		grade.texture = null
	songicon.texture = UserData.song_list[UserData.song_id].icon
	songcontainer.texture_normal = jacket[song.color]
	set_grade(song)
	set_score(song)
	set_infom(song)
	_on_background_switch()	
	$SongContainerAnimation.play("SongContainer")
	$AnimationPlayer.play("IN")
func set_grade(song):
	if UserData.difficulty in song.difficulty:
		var chart = song.diff_chart[UserData.difficulty] as ChartData
		grade.texture = chart.get_grade()
	else:
		grade.texture = null
func set_score(song):
	if UserData.difficulty in song.difficulty:
		var chart = song.diff_chart[UserData.difficulty] as ChartData
		score.text = chart.score
	else:
		score.text = null
func set_infom(song:Song):
		song_name.text = song.name
		song_author.text = song.song_author
		song_bpm.text = str(int(song.bpm))
func _on_song_container_pressed() -> void:
	$SongContainerAnimation.play("SongContainer")
func _on_icon_pressed() -> void:
	for x:SongCard in songcard:
		x.body.mouse_filter = Control.MOUSE_FILTER_IGNORE
	charselect.anim_in()
	songlist.mouse_filter = MOUSE_FILTER_IGNORE
	songcontainer.mouse_filter = MOUSE_FILTER_IGNORE
func _on_exit_pressed() -> void:
	var char = UserData.char_list[UserData.current_char_id]
	charicon.texture = char.icon[char.default]
	for x:SongCard in songcard:
		x.body.mouse_filter = Control.MOUSE_FILTER_STOP
	songcontainer.mouse_filter  = MOUSE_FILTER_STOP
	songlist.mouse_filter = MOUSE_FILTER_STOP
func _on_diff_switch():
	set_infom(UserData.song_list[UserData.song_id])
	set_score(UserData.song_list[UserData.song_id])
	set_grade(UserData.song_list[UserData.song_id])
func _on_background_switch():
	var tween = create_tween()
	tween.set_parallel(true)
	if songcard[UserData.song_id].color == "Dark":
		tween.tween_property($BG/Light,"modulate",Color(1,1,1,0),0.2)
		tween.tween_property($BG/Dark,"modulate",Color(1,1,1,1),0.2)
	if songcard[UserData.song_id].color == "Light":
		tween.tween_property($BG/Light,"modulate",Color(1,1,1,1),0.2)
		tween.tween_property($BG/Dark,"modulate",Color(1,1,1,0),0.2)
func signal_connect():
	charselect.exit.connect(_on_exit_pressed)
	songlist.set_finished.connect(setup)
	UserData.song_switch.connect(_on_song_switch)
	UserData.difficulty_switch.connect(_on_diff_switch)
