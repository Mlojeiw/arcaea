extends Control
@onready var Otexture = $Otexture as SubViewport
@onready var viewport := $SubViewport as SubViewport
@onready var track_sprite := $SubViewport/Node3D/Container/Body as Sprite3D
@onready var display := $TextureRect as TextureRect
@export var scroll_speed: float = 0.6
var track_material: StandardMaterial3D 
var track = {
	"Light":preload("res://picture/game/track/track.png"),
	"Drak":preload("res://picture/game/track/track_dark.png"),
}
func _ready():
	set_track_texture(UserData.song_list[UserData.song_id])
func set_track_texture(song:Song):
	match song.color:
		"Light":
			for x:TextureRect in Otexture.get_children():
				x.texture = track["Light"]
		"Dark":
			for x:TextureRect in Otexture.get_children():
				x.texture = track["Dark"]		
	await RenderingServer.frame_post_draw
	track_sprite.texture = Otexture.get_texture()
	track_material = StandardMaterial3D.new()
	track_material.albedo_texture = Otexture.get_texture()
	track_material.shading_mode = StandardMaterial3D.SHADING_MODE_UNSHADED
	track_material.uv1_scale = Vector3(1, 1, 1)  
	track_material.uv1_offset = Vector3(0, 0, 0)    
	track_sprite.material_override = track_material
	await get_tree().process_frame
	display.texture = viewport.get_texture()
func _process(delta):
	await RenderingServer.frame_post_draw
	var offset = track_material.uv1_offset
	offset.y -= scroll_speed * delta
	offset.y = fmod(offset.y, 1.0)
	track_material.uv1_offset = offset
