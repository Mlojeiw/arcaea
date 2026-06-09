extends Node3D
var start_time:float = -1
var end_time
var lane:int = 0
var ahead = GameManager.ahead
@onready var speed: float = (far_y - judge_line_y) / ahead
var judge_line_y = -17.5
var far_y = 10
var lane_center = [-2.9,-0.95,0.95,2.9]
func _ready() -> void:
	position.z = 0.8
func _process(delta: float) -> void:
	if start_time < 0:
		return
	if position.y > far_y:
		visible = false
	else:
		visible = true
	var current_time = GameManager.current_song_time
	var delta_time = start_time - current_time 
	position.y = judge_line_y + delta_time * speed
	var t = clamp(delta_time / ahead, 0.0, 1.0)         # 剩余时间比例（1 = 刚生成，0 = 到达）
	self.scale.y = lerp(1.0, 2.0, t) 
	if position.y < judge_line_y  - 0.5:
		queue_free()
func setup(note_data: Note):
	match note_data.type:
		Note.note_type.NOTE:
			start_time = note_data.start_time
			end_time = note_data.start_time
		Note.note_type.HOLD_NOTE:
			start_time = note_data.start_time
			end_time = note_data.end_time
	lane = note_data.lane
	position.x = lane_center[lane]
