class_name SongCard extends Control
var diff_number: Dictionary = {
}
var difficulty: Array[String] = []
var diff_score = {
	"past":"00'000'000",
	"present":"00'000'000",
	"future":"00'000'000",
	"beyond":"00'000'000",
	"eternal":"00'000'000",
}
var corner1_res = {
	"past":load("res://picture/song_select/song_cell_corner_0.png"),
	"present":load("res://picture/song_select/song_cell_corner_1.png"),
	"future":load("res://picture/song_select/song_cell_corner_2.png"),
	"eternal":load("res://picture/song_select/song_cell_corner_4.png"),
	"beyond":load("res://picture/song_select/song_cell_corner_suki.png")
}
var dir = {
	"Light":load("res://picture/song_select/song_cell_corner_light.png"),
	"Dark":load("res://picture/song_select/song_cell_corner_dark.png"),
	
}
var grade = {
	"ex" = load("res://picture/grade/ex.png"),
	"exp" = load("res://picture/grade/explus.png"),
	"a" = load("res://picture/grade/a.png"),
	"aa" = load("res://picture/grade/aa.png"),
	"b" = load("res://picture/grade/b.png"),
	"c" = load("res://picture/grade/c.png"),
	"d" = load("res://picture/grade/d.png"),
}
var clear_type = {
	"easy":load("res://picture/clear_type/easy.png"),
	"fail":load("res://picture/clear_type/fail.png"),
	"full":load("res://picture/clear_type/full.png"),
	"normal":load("res://picture/clear_type/normal.png"),
	"hard":load("res://picture/clear_type/hard.png"),
	
	"pure":load("res://picture/clear_type/pure.png"),
}
@onready var songicon = $Body/Container/SongIcon
@onready var body = $Body
@onready var select = $WasSelect
@onready var corner1 = $Corner/Corner1
@onready var corner2 = $Corner/Corner2
@onready var corner_diff = $Corner/Corner1/diff
@onready var bg = $Body/Container/BG
@onready var start = $Body/Start
@onready var song_name = $Body/Container/Label
@onready var anim = $AnimationPlayer
@onready var bg_grade = $bg/Rank1
@onready var bg_clear_type = $bg/Rank2
var was_selected: bool = false
var tween:Tween
var id: int
var icon
var init_pos 
var color:String
var s:Song
signal inGame(song:Song)
func _ready() -> void:
	signal_connect()
func setup(song: Song):
	s = song
	id = song.id
	icon = song.icon
	song_name.text = song.name
	color = song.color
	difficulty = song.difficulty
	songicon.texture = song.icon
	corner2.texture = dir[song.color]
	corner1.texture = corner1_res[UserData.difficulty]
	set_rank()
	for x in difficulty:
		if song.diff_chart.has(x):
			diff_number[x] = song.get_diff_number(x)
			diff_score[x] = song.diff_chart[x].score
	if song.id == UserData.song_id:
		was_selected = true
		select.visible = true
		bg.visible = true
		start.visible = true
	else:
		was_selected = false
		select.visible = false
		bg.visible = false
		start.visible = false
	if not UserData.difficulty in difficulty:
		self.visible = false
	else:
		self.visible = true
		corner_diff.text = diff_number[UserData.difficulty]
func _on_body_pressed() -> void:
	if was_selected:
		inGame.emit()
		return
	UserData.set_song_id(id)
func _on_song_switch(song:Song):
	if UserData.song_id == id:
		start.visible = true
		was_selected = true
		select.visible = true
		bg.visible = true
		anim.play("START")
		tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(select,"modulate",Color(1,1,1,1),0.3)
	else:
		start.visible = false
		was_selected = false
		select.visible = false
		bg.visible = false
		songicon.modulate = Color(1,1,1,1)
		anim.stop()
func get_container_size():
	return $Body.size
func _on_diff_switch():
	self.visible = false
	if UserData.difficulty in difficulty:
		self.visible = true
		corner_diff.text = diff_number[UserData.difficulty]
		corner1.texture = corner1_res[UserData.difficulty]
	set_rank()
func kill_tween():
	if tween:
		tween.kill()
		tween = null
func set_pos(pos):
	self.position = pos
	init_pos = pos 
func set_rank():
	if UserData.difficulty in difficulty:
		var chart = s.diff_chart[UserData.difficulty] as ChartData
		if chart.grade != "":
			bg_grade.texture = grade[chart.grade]
		else:
			bg_grade.texture = null
		if chart.clear_type != "":
			bg_clear_type.texture = clear_type[chart.clear_type]
		else:
			bg_clear_type.texture = null
func signal_connect():
	UserData.song_switch.connect(_on_song_switch)
	UserData.difficulty_switch.connect(_on_diff_switch)
	
