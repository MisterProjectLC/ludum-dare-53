extends Camera2D

@export var ZOOM_SENSITIVITY = 1.0

@export var player_path : NodePath
@onready var player = get_node(player_path)

var MIN_ZOOM = 0.05
var MAX_ZOOM = 8


func change_zoom(delta):
	set_zoom(get_zoom() + delta * sqrt(zoom.x))
	if zoom.x <= MIN_ZOOM:
		set_zoom(Vector2.ONE * MIN_ZOOM)
	elif zoom.x > MAX_ZOOM:
		set_zoom(Vector2.ONE * MAX_ZOOM)
	
	GlobalNode.set_camera_zoom(zoom.x)
