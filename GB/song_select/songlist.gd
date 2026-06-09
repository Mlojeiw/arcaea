extends Control
const  topbar_h = 100
@onready var container = $Control
var scroll_offset:float = topbar_h
var target_offset:float = topbar_h
var base = Vector2.ZERO
var diff 
var card_h
var max_offset = topbar_h
var min_offset:float = 0
var active_tween: Array[Tween] = []
var scroll_velocity: float = 0.0         
var velocity_decay: float = 0.92        
var wheel_sensitivity: float = 1500.0    
@onready var song_pos = Vector2(440,0)
@onready var offset = Vector2(-30,180)
@onready var scroll_ratio = offset.x / offset.y 
@onready var songcard:Array[SongCard]
const CHARTSELECTION = preload("res://GB/song_select/song_card.tscn")
signal set_finished
func  _ready() -> void:
	signal_connect()
func setup():
	for song:Song in UserData.song_list:
		var x = CHARTSELECTION.instantiate() as SongCard
		container.add_child(x)
		songcard.append(x)
		x.setup(song)
		x.set_pos(song_pos)
		card_h = x.get_container_size().y
		diff = offset.y - x.get_container_size().y 
		if x.id == UserData.song_id:
			x.anim.play("START")
	_rearrange_cards()
	set_finished.emit()
func _process(delta: float) -> void:
	target_offset += scroll_velocity * delta
	if target_offset > max_offset:
		target_offset = max_offset
		scroll_velocity = 0.0           
	elif target_offset < min_offset:
		target_offset = min_offset
		scroll_velocity = 0.0
	scroll_velocity *= velocity_decay
	if abs(scroll_velocity) < 0.5:
		scroll_velocity = 0.0
	scroll_offset = lerp(scroll_offset, target_offset, 0.3)
	scroll_offset = clamp(scroll_offset, min_offset,max_offset)
	container.position.y = base.y + scroll_offset
	container.position.x = base.x + scroll_offset * scroll_ratio
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP :
			scroll_velocity += wheel_sensitivity
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN :
			scroll_velocity -= wheel_sensitivity
func _rearrange_cards():
	var pos = song_pos
	for x in songcard:
		if x.visible:
			x.set_pos(pos)
			x.kill_tween()
			var tween = create_tween()
			x.position  = x.init_pos + Vector2(600,0)
			tween.set_parallel(true)
			tween.set_ease(Tween.EASE_OUT)
			tween.set_trans(Tween.TRANS_QUAD)
			tween.tween_property(x,"position",x.init_pos,0.3)
			x.tween = tween
			pos += offset
			active_tween.append(tween)
	scroll_to_select_song()
	reset_clamp()

func _on_diff_switch():
	call_deferred("_rearrange_cards")
func  _on_song_switch(song:Song):
	var card = 0
	var sc
	for x in songcard:
		if x.visible == true:
			card += 1
		if x.id == song.id:
			sc = x
			break
	if ((card - 1) * diff + card * card_h + topbar_h) + scroll_offset >= 1080 - card_h - diff:
		scroll_velocity -= 2200.0
	if sc.position.y + scroll_offset <= card_h + diff:
		scroll_velocity += 2200.0

func signal_connect():
	UserData.difficulty_switch.connect(_on_diff_switch)
	UserData.song_switch.connect(_on_song_switch)
func scroll_to_select_song():
	var card = 0
	var sc = songcard[UserData.song_id]
	for x:SongCard in songcard:
		if x.visible:
			card += 1
		if x == sc:
			break
	var card_top = (card - 1) * offset.y
	var target_y = size.y / 2.0 - card_top - card_h / 2.0
	target_offset = clamp(target_y, min_offset, max_offset)

func reset_clamp():
	var card = 0
	for x in songcard:
		if x.visible == true:
			card += 1
	if ((card - 1) * diff + card * card_h + topbar_h) > 1080:
		min_offset = 1080 - ((card - 1) * diff + card * card_h + topbar_h)
	else:
		min_offset = topbar_h - 20
