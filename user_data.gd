extends Node
signal char_switch(char:Char)
signal song_switch(song:Song)
signal difficulty_switch()
var char_name_id = {
	"Hikari":0,
	"Tairitsu":1,
}
var char_id_name= {
	0: "Hikari",
	1: "Tairitsu",
}
var current_char_id : int = 0
var song_id: int = 0
var difficulty: String = "past"
var song_list: Array[Song] = []
var char_list: Array[Char] = []
const  CONFIG_PATH = "user://user_data.cfg"
func _ready() -> void:
	_load()

func _save():
	var config = ConfigFile.new()
	config.set_value("user","current_char_id",current_char_id)
	config.set_value("user","song_select_id",song_id)
	config.set_value("user","difficulty",difficulty)
	config.save(CONFIG_PATH)
	var wapper = CharList.new()
	var x = SongList.new()
	x.songlist = song_list
	wapper.charlist = char_list
	ResourceSaver.save(wapper,"user://char_data.tres")
	ResourceSaver.save(x,"user://song_data.tres")
	
func _load():
	DirAccess.remove_absolute("user://char_data.tres")
	DirAccess.remove_absolute("user://song_data.tres")
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
	if  ResourceLoader.exists("user://song_data.tres"):
		var data =  ResourceLoader.load("user://song_data.tres")
		song_list = data.songlist
	else:
		var note:Array[Note] = []
		var bp: Array[float] = []
		var testify = Song.new()
		testify.name = "Testify"
		testify.song_author = "void/星熊南巫"
		testify.id = 0
		testify.icon = load("res://picture/songicon/testify.jpg")
		testify.color = "Light"
		testify.difficulty = ["past","future"] as Array[String]
		song_list.append(testify)
		var id = add_song("sheriruthrmx",["future"],200,"Grimoire of Darkness",load("res://picture/songicon/sheriruthrmx.jpg"),"Dark")
		song_list[id].add_chart(preload("res://music/song/Arcaea_Team - Sheriruth.mp3"),note,bp,{"future":"10"},"00'000'000")
		testify.add_chart(preload("res://music/song/Arcaea_Team - Testify -Official Music Video-.mp3"),note,bp,{"past":"8+"},"00'000'000")
		testify.add_chart(preload("res://music/song/Arcaea_Team - Testify -Official Music Video-.mp3"),note,bp,{"future":"11"},"98'898'056")
		testify.add_chart(preload("res://music/song/Arcaea_Team - Testify -Official Music Video-.mp3"),note,bp,{"present":"9+"},"96'800'0577")
		id = add_song("archav",[],198,"Feryquitous",load("res://picture/songicon/arcahv.jpg"),"Light")
		song_list[id].add_chart(preload("res://music/song/arcahv.ogg"),note,bp,{"future":"9+"},"00'000'000")
		song_list[id].add_chart(preload("res://music/song/arcahv.ogg"),note,bp,{"past":"6"},"90'000'000")
		
	var config = ConfigFile.new()
	if config.load(CONFIG_PATH) != OK:
		self.current_char_id = 0
		return
	self.current_char_id = config.get_value("user","current_char_id",0)
	self.song_id = config.get_value("user","song_id",0)
	self.difficulty = config.get_value("user","difficulty","past")
func set_current_char_id(value):
	var size = char_list.size()
	if size == 0 :
		current_char_id = 0
	else:
		current_char_id = ((value % size) + size) % size
		char_switch.emit(char_list[current_char_id])
		_save()
func set_song_id(value):
	if song_id != value:
		var size = song_list.size()
		if size == 0:
			song_id = 0
		else:
			song_id = ((value % size) + size) % size
		song_switch.emit(song_list[song_id])
		_save()
func set_difficulty(value):
	if difficulty != value:
		self.difficulty = value
		difficulty_switch.emit()
		_save()
func add_song(name:String,diff:Array[String],bpm:float,authour:String,icon:Resource,color:String):
	var new = Song.new()
	new.name = name
	new.difficulty = diff
	new.id = song_list.size()
	new.bpm = bpm
	new.song_author = authour
	new.icon = icon
	new.color = color	
	song_list.append(new)
	_save()
	return new.id
