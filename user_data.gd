extends Node
signal char_switch(char:Char)
var char_name_id = {
	"Hikari":0,
	"Tairitsu":1,
}
var char_id_name= {
	0: "Hikari",
	1: "Tairitsu",
}
var current_char_id : int = 0 :
	set(value):
		var size = char_list.size()
		if size == 0 :
			current_char_id = 0
		else:
			current_char_id = ((value % size) + size) % size
		char_switch.emit(char_list[current_char_id])
		_save()
var char_list : Array[Char] = []
const  CONFIG_PATH = "user://user_data.cfg"
	
func _ready() -> void:
	_load()

func _save():
	var config = ConfigFile.new()
	config.set_value("user","current_char_id",current_char_id)
	config.save(CONFIG_PATH)
	var wapper = CharList.new()
	wapper.charlist = char_list
	ResourceSaver.save(wapper,"user://char_data.tres")
func _load():
	if ResourceLoader.exists("user://char_data.tres"):
		var data = ResourceLoader.load("user://char_data.tres")
		char_list = data.charlist

	else:
		var hikari = Char.new()
		hikari.id = 0
		hikari.name = "Hikari"
		hikari.level = 0
		
		hikari.texture = [
			load("res://picture/character/char/0.png"),
			load("res://picture/character/char/0u.png"),
			load("res://picture/character/char/0o.png"),
			
		]
		
		hikari.icon = [
			load("res://picture/character/charicon/0_icon.png"),
			load("res://picture/character/charicon/0u_icon.png"),
			load("res://picture/character/charicon/0o_icon.png"),
			
		]
		hikari.default = 0
		char_list.append(hikari)
		var tairitsu = Char.new()
		tairitsu.id = 1
		tairitsu.name = "Tairitsu"
		tairitsu.level = 0
		
		tairitsu.texture =[
			load("res://picture/character/char/1.png"),
			load("res://picture/character/char/1u.png"),
			load("res://picture/character/char/1o.png"),
		]
		tairitsu.icon = [
			load("res://picture/character/charicon/1_icon.png"),
			load("res://picture/character/charicon/1u_icon.png"),
			load("res://picture/character/charicon/1o_icon.png"),
			
		]
		tairitsu.default = 0
		char_list.append(tairitsu)
		_save()
	var config = ConfigFile.new()
	if config.load(CONFIG_PATH) != OK:
		self.current_char_id = 0
		return
	self.current_char_id = config.get_value("user","current_char_id",0)
