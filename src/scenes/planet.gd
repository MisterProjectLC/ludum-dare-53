extends Node2D

@export var dialog_title = ""
@export var active = false

@onready var area = $Area2D


signal spaceship_approached(planet)


func get_dialog_title():
	return dialog_title


func set_active(t):
	active = t
	$ZoomSprite.visible = t


func _on_area_2d_body_entered(_body):
	if !active:
		return
	
	area.set_deferred("monitoring", false)
	emit_signal("spaceship_approached", self)


func _on_long_range_detector_body_entered(_body):
	$ZoomSprite.visible = true


func _on_long_range_detector_body_exited(_body):
	$ZoomSprite.visible = false
