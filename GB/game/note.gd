class_name  Note extends Resource
enum note_type{
	NOTE,
	HOLD_NOTE,
}
@export var type: note_type
@export var start_time: float
@export var end_time: float
@export var texture_normal: Resource
@export var texture_pressed: Resource
@export var lane: int
#track 1~6
