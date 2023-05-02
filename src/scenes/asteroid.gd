extends AstralBody


func _on_long_range_detector_body_entered(_body):
	if !active or visited:
		return
	
	$ZoomSprite.visible = true
	$DetectionSound.play()


func _on_long_range_detector_body_exited(_body):
	$ZoomSprite.visible = false
