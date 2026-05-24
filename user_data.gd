extends Node

signal char_switch(char_id:int)
signal get_new_char
var current_char_id : int = 0 :
	set(value):
		current_char_id = value
		char_switch.emit(value)
		_save()
var user_char_list : Array = ["Hikari","Tairitsu"] :
	set(value):
		user_char_list.append(value)
		get_new_char.emit()
	
func _ready() -> void:
	_load()
const  CONFIG_PATH = "user://user_data.cfg"

func _process(delta: float) -> void:
	pass
func _save():
	var config = ConfigFile.new()
	config.set_value("user","char_id",current_char_id)
	config.save(CONFIG_PATH)
	config.set_value("user","user_char_list",user_char_list)
func _load():
	var config = ConfigFile.new()
	if config.load(CONFIG_PATH) != OK:
		current_char_id = 0
		return
	current_char_id = config.get_value("user","char_id")
	
