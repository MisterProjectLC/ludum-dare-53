extends Node2D

@export var ZOOM_SENSITIVITY = 1.0
@export_range(0, 1) var ZOOM_LERP = 0.9

@export var player_path : NodePath
@onready var player = get_node(player_path)

@onready var Camera = $Camera2D

var player_on_screen = true

func _process(delta):
	global_position = lerp(global_position, player.global_position, ZOOM_LERP)

	Camera.change_zoom(Vector2.ZERO)
	if Input.is_action_pressed("zoom_out") or !player_on_screen:
		Camera.change_zoom(-Vector2.ONE * ZOOM_SENSITIVITY * delta)
	elif Input.is_action_just_released("zoom_out_mouse"):
		Camera.change_zoom(-Vector2.ONE * ZOOM_SENSITIVITY * 10 * delta)
	
	elif Input.is_action_pressed("zoom_in"):
		Camera.change_zoom(Vector2.ONE * ZOOM_SENSITIVITY * delta)
	elif Input.is_action_just_released("zoom_in_mouse"):
		Camera.change_zoom(Vector2.ONE * ZOOM_SENSITIVITY * 10 * delta)


func _on_spaceship_on_screen_changed(on_screen):
	player_on_screen = on_screen
	
