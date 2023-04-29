extends Node2D

@export var dialog_title = ""

signal spaceship_approached(planet)


func get_dialog_title():
	return dialog_title


func _on_area_2d_body_entered(_body):
	emit_signal("spaceship_approached", self)
