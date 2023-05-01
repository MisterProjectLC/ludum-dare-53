extends AstralBody


func set_active(t):
	super.set_active(t)
	if !hidden_body:
		$ZoomSprite.visible = t
