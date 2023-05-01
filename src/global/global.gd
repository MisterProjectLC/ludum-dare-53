extends Node

signal on_cutscene_changed(in_cutscene)

var music_volume = 0.5
var sound_volume = 0.5
var souvenirs = [false, false, false, false, false, false, false]

var _in_cutscene = false
func set_in_cutscene(value):
	_in_cutscene = value
	emit_signal("on_cutscene_changed", value)

func get_in_cutscene():
	return _in_cutscene


var camera_zoom = 0.25
func get_camera_zoom():
	return camera_zoom

func set_camera_zoom(z):
	camera_zoom = z

@export var menu_mouse: Texture2D
@export var game_mouse: Texture2D


@export var _debug = false
func in_debug():
	return _debug
