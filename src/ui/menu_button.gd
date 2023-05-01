extends Button


# Called when the node enters the scene tree for the first time.


func _on_mouse_entered():
	$Star.visible = true


func _on_mouse_exited():
	$Star.visible = false
