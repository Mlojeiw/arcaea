class_name  Note extends Resource
enum note_type{
	NOTE,
	HOLD_NOTE,
}
@export var type: String
@export var start_time: float
@export var end_time: float
@export var track: int
#track 1~6
