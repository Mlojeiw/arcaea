class_name ChartData extends Resource
signal set_finished
var grade_texture = {
	"ex" = load("res://picture/grade/ex.png"),
	"exp" = load("res://picture/grade/explus.png"),
	"a" = load("res://picture/grade/a.png"),
	"aa" = load("res://picture/grade/aa.png"),
	"b" = load("res://picture/grade/b.png"),
	"c" = load("res://picture/grade/c.png"),
	"d" = load("res://picture/grade/d.png"),
}
@export var score:String 
@export var song: Resource
@export var noteList: Array[Note]
@export var bpm: Array[float]
@export var diff:Dictionary
@export var grade:String = ""
@export var clear_type:String = ""
func set_result(s,g,c):
	score = s
	grade = g
	clear_type = c
	set_finished.emit()	
func get_grade(): 
	if grade != "":
		return grade_texture[grade]
