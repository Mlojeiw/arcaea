class_name NOTE extends Sprite3D
var start_time:float = -1
var end_time:float
var activate:bool = false
var lane:int = 0
var ahead = GameManager.ahead
var judge_line_y = -18
var far_y = 20
var type
var score:int
var lane_center = [-2.9,-0.95,0.95,2.9]
var speed: float 
const PURE= 0.025
const FAR  = 0.050 
const  LOST = 0.10
signal was_hitted(note,is_hit,type)
func _ready() -> void:
	pixel_size = 0.01
	position.z = 0.8
	position.y = far_y + 10
func _process(delta: float) -> void:
	if start_time < 0:
		return
	var current_time = GameManager.current_song_time
	var delta_time = start_time - current_time 
	position.y = judge_line_y + delta_time * speed
	if type == Note.note_type.NOTE:
		var t = clamp(delta_time / ahead, 0.0, 1.0)         
		scale.y = lerp(1.0, 2.0, t)
func setup(note_data: Note):
	speed  = (far_y - judge_line_y) / ahead
	texture = note_data.texture_normal
	type = note_data.type
	lane = note_data.lane
	position.x = lane_center[lane]
	match note_data.type:
		Note.note_type.NOTE:
			start_time = note_data.start_time
			end_time = note_data.start_time
		Note.note_type.HOLD_NOTE:
			start_time = note_data.start_time
			end_time = note_data.end_time
func try_note(hit_time:float):
	if start_time < 0:
		return
	if type == Note.note_type.NOTE:
		if start_time > hit_time:
			var diff = start_time - hit_time 
			if diff  <= PURE:
				was_hitted.emit(self,true,"pure")
				queue_free()
				return true
			elif diff <= FAR:
				was_hitted.emit(self,true,"far")
				queue_free()
				return true
			elif  diff <= LOST:
				was_hitted.emit(self,false,"lost")
				queue_free()
				return false
		else :
			var diff = hit_time - start_time 
			if diff <= PURE:
				was_hitted.emit(self,true,"pure")
				queue_free()
				return true
			elif diff <= FAR:
				was_hitted.emit(self,true,"far")
				queue_free()
				return true
			else:
				was_hitted.emit(self,false,"lost")
				queue_free()
				return false
	return false
func try_hold(hit_time:float):
	if hit_time >= start_time and hit_time <= end_time:
		activate = true
	
