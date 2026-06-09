extends Control
@onready var songicon = $Container/Score/TextureRect/ColorRect/TextureRect
@onready var bar = $Container/HPcontainer/HP/ColorRect/Bar
@onready var songname = $Container/Score/TextureRect/Name
@onready var authour = $Container/Score/TextureRect/Authour
@onready var notecontainer = $Container/TrackRoot/SubViewport/Node3D/Container/Notes
var current_song_time:float
var test_notes: Array[Note] = []   
var note_index:int
const note_scene = preload("res://GB/game_play/note.tscn")
func spawn_note(note_data:Note):
	var note = note_scene.instantiate()
	note.setup(note_data)   
	notecontainer.add_child(note)
func _ready() -> void:
	set_game(UserData.song_list[UserData.song_id])

func _process(delta: float) -> void:
	if $Music.playing:
		GameManager.current_song_time = $Music.get_playback_position()
	else:
		GameManager.current_song_time = 0.0
	while note_index < test_notes.size():
		var note_data = test_notes[note_index]
		if GameManager.current_song_time + GameManager.ahead >= note_data.start_time:
			spawn_note(note_data)   # 使用已有的 spawn_note 函数
			note_index += 1
		else:
			break
	bar.position.y -= 10 * delta
	bar.position.y = clamp(bar.position.y,0,488)
func set_game(song:Song):
	$Music.stream = song.diff_chart[UserData.difficulty].song
	$Music.play()
	bar.position = Vector2(0,487)
	songicon.texture = song.icon
	songname.text = song.name
	authour.text = song.song_author
	_create_test_notes()
func _create_test_notes():
	test_notes.clear()
	note_index = 0
	var test_data = [
		{ "time": 2.0, "lane": 0 },
		{ "time": 2.5, "lane": 1 },
		{ "time": 3.0, "lane": 2 },
		{ "time": 3.5, "lane": 3 },
		{ "time": 4.0, "lane": 0 },
		{ "time": 4.5, "lane": 1 },
		{ "time": 5.0, "lane": 2 },
		{ "time": 5.5, "lane": 3 },
	]
	for data in test_data:
		var note = Note.new()
		note.type = Note.note_type.NOTE
		note.start_time = data["time"]
		note.lane = data["lane"]
		note.texture_normal = preload("res://picture/game/note/note_dark.png")  # 替换为你的音符纹理路径
		test_notes.append(note) 
