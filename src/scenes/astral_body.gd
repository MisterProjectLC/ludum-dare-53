extends Node2D
class_name AstralBody

@export var dialog_title = ""
@export var active = false
@export var hidden_body = false
@export var image : Texture2D

@onready var area = $Area2D

signal spaceship_approached(planet)


func _ready():
	$Sprite.texture = image

func set_dialog_title(t):
	dialog_title = t


func get_dialog_title():
	return dialog_title


func set_active(t):
	active = t


func _on_area_2d_body_entered(_body):
	if !active:
		return
	
	set_active(false)
	emit_signal("spaceship_approached", self)


func _on_long_range_detector_body_entered(_body):
	if !active:
		return
	
	$ZoomSprite.visible = true
	$DetectionSound.play()


func _on_long_range_detector_body_exited(_body):
	$ZoomSprite.visible = false
