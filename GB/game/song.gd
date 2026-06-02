class_name Song extends Resource

@export var name: String
@export var song_author: String
@export var bpm: float
@export var icon: Resource
@export var id: int
@export var difficulty: Array[String]
@export var diff_chart: Dictionary = {} #{String: ChartData}
@export var color: String
func get_diff_number(diff:String):
	if diff in difficulty:
		return diff_chart[diff].diff[diff]
func add_chart(song:Resource,notelist:Array[Note],bpmlist:Array[float],diff:Dictionary,score:String):
	if not diff.keys()[0] in difficulty:
		difficulty.append(diff.keys()[0]) 
	var new = ChartData.new()
	new.noteList = notelist
	new.diff = diff
	new.bpm = bpmlist
	new.song = song
	new.score = score
	diff_chart[diff.keys()[0]] = new
