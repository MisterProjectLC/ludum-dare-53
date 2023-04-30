extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	scale = Vector2.ONE/(5*GlobalNode.get_camera_zoom())
	modulate.a = clamp((0.1-GlobalNode.get_camera_zoom())/0.1, 0, 1)
