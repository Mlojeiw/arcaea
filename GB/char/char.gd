class_name Char
extends Resource
signal default_switch(char:Char)
@export var id: int
@export var name:  String
@export var level: int
@export var texture = []
@export var icon = []
@export var default:int = 0
func add_default():
	var size = texture.size()
	default += 1
	default = ((default % size) + size) % size
	UserData._save()
	default_switch.emit(self)
