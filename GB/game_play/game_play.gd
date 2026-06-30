extends Control
@onready var songicon = $Container/Score/TextureRect/ColorRect/TextureRect
@onready var bar = $Container/HPcontainer/HP/ColorRect/Bar
@onready var songname = $Container/Score/TextureRect/Name
@onready var authour = $Container/Score/TextureRect/Authour
@onready var notecontainer = $Container/TrackRoot/SubViewport/Node3D/Container/Notes
@onready var score = $Container/Score/Label
@onready var hitlist = [
	$Control/Hit1,
	$Control/Hit2,
	$Control/Hit3,
	$Control/Hit4,
]
@onready var effectlist = [
	$Control2/Effect1,
	$Control2/Effect2,
	$Control2/Effect3,
	$Control2/Effect4,
]
@onready var tracklist = [
	$Container/TrackRoot/SubViewport/Node3D/Container/Effect1,
	$Container/TrackRoot/SubViewport/Node3D/Container/Effect2,
	$Container/TrackRoot/SubViewport/Node3D/Container/Effect3,
	$Container/TrackRoot/SubViewport/Node3D/Container/Effect4,
]
@onready var hit_sounds = [
	$SoundEffect/Hit1,
	$SoundEffect/Hit2,
	$SoundEffect/Hit3,
	$SoundEffect/Hit4,
]
var is_used:bool = false
var effect_pool = [[],[],[]]
var texture = {
	"pure":load("res://picture/game/hit/hit_pure.png"),
	"far":load("res://picture/game/hit/hit_far.png"),
	"lost":load("res://picture/game/hit/hit_lost.png"),
}
var judge_line_y = -17.5
var activate_note = [[],[],[],[]]
var current_song_time:float
var test_notes: Array[Note] = []   
var note_index:int
var current_score:int = 0
const note_scene = preload("res://GB/game_play/note/note.tscn")
const MAX_EFFECTS_PER_LANE = 20
func spawn_note(note_data:Note):
	var note = note_scene.instantiate()
	note.setup(note_data)  
	note.was_hitted.connect(_on_note_hit)
	activate_note[note.lane].append(note)
	notecontainer.add_child(note)
	
#func _ready() -> void:
	#set_game(UserData.song_list[UserData.song_id])
func _process(delta: float) -> void:
	if $Music.playing:
		GameManager.current_song_time = $Music.get_playback_position()
	else:
		GameManager.current_song_time = 0.0
	while note_index < test_notes.size():
		var note_data = test_notes[note_index]
		if GameManager.current_song_time + GameManager.ahead >= note_data.start_time:
			spawn_note(note_data)   
			note_index += 1
		else:
			break
	bar.position.y -= 10 * delta
	bar.position.y = clamp(bar.position.y,0,488)
func _input(event: InputEvent) -> void:
	var lane = -99
	if event.is_action("track_0"): 
		lane = 0
	elif event.is_action("track_1"): 
		lane = 1
	elif event.is_action("track_2"):
		lane = 2
	elif event.is_action("track_3"): 
		lane = 3
	if lane >=0:
		if event.is_pressed() and not event.is_echo():
			tracklist[lane].anim_start()
		elif event.is_released():
			tracklist[lane].anim_end()
		var notes = activate_note[lane]
		while not notes.is_empty():
			var first_note = notes[0]
			if not is_instance_valid(first_note) or first_note.position.y < judge_line_y - 4:
				notes.pop_front()
			else:
				break  		
	if event.is_pressed() and lane >= 0 and !activate_note[lane].is_empty():
		var hit_time = GameManager.current_song_time
		var note:NOTE = activate_note[lane][0]
		if note.try_note(hit_time) and note.type == Note.note_type.NOTE:
			hit_sounds[lane].play()
			activate_note[lane].pop_front()
		elif note.type == Note.note_type.HOLD_NOTE :
			hit_sounds[lane].play()
			
func set_game(song:Song):
	is_used = true
	$Music.stream = song.diff_chart[UserData.difficulty].song
	$Music.play()
	bar.position = Vector2(0,487)
	songicon.texture = song.icon
	songname.text = song.name
	authour.text = song.song_author
	score.text = format_score(current_score)
	set_effect(song)
	_create_test_notes()
func set_effect(song:Song):
	match song.color:
		"Light":
			for x in hitlist:
				x.animation = "light"
		"Dark":
			for x in hitlist:
				x.animation = "conflict"	
func _create_test_notes():
	test_notes.clear()
	note_index = 0
	var test_data = [
		# 普通音符热身
		{ "time": 2.0, "lane": 0, "type": "note" },
		{ "time": 2.5, "lane": 1, "type": "note" },
		{ "time": 3.0, "lane": 2, "type": "note" },
		{ "time": 3.5, "lane": 3, "type": "note" },

		# 短长按（0.5 秒）
		{ "time": 4.0, "lane": 0, "type": "hold", "end_time": 4.5 },
		{ "time": 4.5, "lane": 2, "type": "note" },

		# 双押长按（同一时间两个长按）
		{ "time": 5.0, "lane": 1, "type": "hold", "end_time": 6.0 },
		{ "time": 5.0, "lane": 3, "type": "hold", "end_time": 6.0 },

		# 普通音符穿插
		{ "time": 5.5, "lane": 0, "type": "note" },
		{ "time": 6.0, "lane": 2, "type": "note" },

		# 中等长度长按（1 秒）
		{ "time": 7.0, "lane": 0, "type": "hold", "end_time": 8.0 },
		{ "time": 7.5, "lane": 3, "type": "note" },

		# 三押混合
		{ "time": 8.5, "lane": 0, "type": "hold", "end_time": 9.5 },
		{ "time": 8.5, "lane": 1, "type": "note" },
		{ "time": 8.5, "lane": 2, "type": "hold", "end_time": 9.0 },

		# 长时值长按（1.5 秒）
		{ "time": 10.0, "lane": 3, "type": "hold", "end_time": 11.5 },
		{ "time": 10.5, "lane": 0, "type": "note" },
		{ "time": 11.0, "lane": 1, "type": "note" },

		# 密集长按 + 单轨连续
		{ "time": 12.0, "lane": 0, "type": "hold", "end_time": 12.5 },
		{ "time": 12.25, "lane": 2, "type": "note" },
		{ "time": 12.5, "lane": 1, "type": "hold", "end_time": 13.0 },
		{ "time": 12.75, "lane": 3, "type": "note" },
		{ "time": 13.0, "lane": 0, "type": "note" },
		{ "time": 13.25, "lane": 2, "type": "hold", "end_time": 13.75 },
		{ "time": 13.5, "lane": 1, "type": "note" },
		{ "time": 14.0, "lane": 3, "type": "note" },
		{ "time": 14.5, "lane": 0, "type": "note" },
	]

	for data in test_data:
		var note = Note.new()
		note.start_time = data["time"]
		note.lane = data["lane"]
		if data["type"] == "hold":
			note.type = Note.note_type.HOLD_NOTE
			note.end_time = data["end_time"]
			note.texture_normal = preload("res://picture/game/note/note_hold.png")  # 长按纹理
		else:
			note.type = Note.note_type.NOTE
			note.texture_normal = preload("res://picture/game/note/note.png")
		test_notes.append(note)
func _on_note_hit(note:NOTE,is_hit,type):
	effectlist[note.lane].anim()
	effectlist[note.lane].texture = texture[type]
	if !is_hit:
		return
	current_score += 251
	score.text = format_score(current_score)
	hitlist[note.lane].visible = true
	hitlist[note.lane].stop()
	hitlist[note.lane].play()
func format_score(score: int) -> String:
	var s = str(score).lpad(8, "0")
	return s.substr(0, 2) + "'" + s.substr(2, 3) + "'" + s.substr(5, 2)
#func try_hit():
	
