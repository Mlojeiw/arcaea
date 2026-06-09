extends Control

@onready var buttons = {
	"past": $Past,
	"present": $Present,
	"future": $Future,
	"eternal": $Eternal,
	"beyond": $Beyond
}
@onready var labels = {
	"past": $Past/Label,
	"present": $Present/Label,
	"future": $Future/Label,
	"eternal": $Eternal/Label,
	"beyond": $Beyond/Label
}
@onready var current_diff = UserData.difficulty
signal _on_button_pressed
func _ready() -> void:
	_signal_connect()
	_set_buttons_group()
	_on_song_switch(UserData.song_list[UserData.song_id])
func _on_buttons_pressed(diff:String):
	_on_button_pressed.emit()
	current_diff = diff
	UserData.set_difficulty(diff)
func _set_buttons_group():
	var group = ButtonGroup.new()
	for x in  buttons.values():
		x.visible = false
		x.button_group = group
		buttons[current_diff].button_pressed = true
func _on_song_switch(song:Song):
	for x in  buttons.values():
		x.visible = false
	for x in song.difficulty:
		buttons[x].visible = true
		labels[x].text = song.get_diff_number(x)
		if not current_diff in song.difficulty:
			current_diff = song.difficulty[0]
			buttons[current_diff].button_pressed = true
			UserData.set_difficulty(current_diff)
func _signal_connect():
	UserData.song_switch.connect(_on_song_switch)
	for x in buttons:
		buttons[x].pressed.connect(_on_buttons_pressed.bind(x))
