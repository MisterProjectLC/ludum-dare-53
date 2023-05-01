extends Button


# Called when the node enters the scene tree for the first time.


func _on_mouse_entered():
	$Star.visible = true
	self.grab_focus()

func _on_mouse_exited():
	if not has_focus():
		$Star.visible = false


func _on_focus_entered():
	$Star.visible = true


func _on_focus_exited():
	if not self.is_hovered():
		$Star.visible = false
