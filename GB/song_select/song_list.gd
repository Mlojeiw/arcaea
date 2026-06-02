extends Control
var scroll_offset = 0.0
var target_offset = 0.0
var base
var container_size
var max_offset:float
var min_offset:float = 84
var song_pos = Vector2(250,0)
@onready var offset = Vector2(-80,180)
@onready var songcard:Array[SongCard]
const CHARTSELECTION = preload("res://GB/song_select/song_card.tscn")
signal set_finished
func  _ready() -> void:
	signal_connect()
func setup():
	for song:Song in UserData.song_list:
		var x = CHARTSELECTION.instantiate() as SongCard
		add_child(x)
		songcard.append(x)
		x.setup(song)
		x.set_pos(song_pos)
		if x.id == UserData.song_id:
			x.anim.play("START")
	_on_diff_switch()
	base = position
	container_size = songcard[0].get_container_size()
	if UserData.song_list.size() * container_size.y > 1080:
		max_offset = UserData.song_list.size() * container_size.y - 1080
	else:
		max_offset = min_offset + 40
	set_finished.emit()
func _process(delta: float) -> void:
	scroll_offset = lerp(scroll_offset, target_offset, 0.3)
	scroll_offset = clamp(scroll_offset, min_offset, max_offset)
	position.y = scroll_offset
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			target_offset -= 40
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			target_offset += 40
	target_offset = clamp(target_offset,min_offset,max_offset)
func _rearrange_cards():
	var pos = song_pos
	for x in songcard:
		if x.visible == true:
			x.set_pos(pos)
			pos += offset
			var tween = create_tween()
			x.position  = x.init_pos + Vector2(60,0)
			tween.set_parallel(true)
			tween.tween_property(x,"position",x.init_pos,0.3)
func _on_diff_switch():
	call_deferred("_rearrange_cards")
func signal_connect():
	UserData.difficulty_switch.connect(_on_diff_switch)
