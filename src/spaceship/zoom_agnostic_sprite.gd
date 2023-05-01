extends Sprite2D

@onready var default_scale = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	default_scale = scale.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	scale = Vector2.ONE * default_scale/(0.5*GlobalNode.get_camera_zoom())
	modulate.a = clamp((1-GlobalNode.get_camera_zoom()), 0, 1)
