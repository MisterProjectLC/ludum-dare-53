extends Node
class_name TextureLoader

static func get_tex_from_title(title):
	var tex = ImageTexture.new()
	tex = load(ProjectSettings.globalize_path("res://assets/" + title + ".png"))
	return tex


static func get_audio_from_title(title):
	var tex = AudioStream.new()
	var path = "res://assets/audio/sfx/chatter/" + title + ".mp3"
	tex = load(ProjectSettings.globalize_path(path))
	return tex
