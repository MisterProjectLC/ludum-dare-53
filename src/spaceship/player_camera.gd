extends Camera2D

@export var ZOOM_SENSITIVITY = 1.0

@export var player_path : NodePath
@onready var player = get_node(player_path)


func change_zoom(delta):
	set_zoom(get_zoom() + delta * sqrt(zoom.x))
	if zoom.x <= 0.01:
		set_zoom(Vector2.ONE * 0.01)
	elif zoom.x > 5:
		set_zoom(Vector2.ONE * 5)
