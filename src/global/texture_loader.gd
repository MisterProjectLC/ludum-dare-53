extends Node
class_name TextureLoader

static func get_tex_from_title(title):
	var tex = ImageTexture.new()
	tex = load(ProjectSettings.globalize_path("res://assets/" + title + ".png"))
	return tex
