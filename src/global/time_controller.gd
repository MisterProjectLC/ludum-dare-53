extends Node

signal paused_game(is_paused)

@onready var timer = $"%Timer"

#var priority = 0
#enum {HIT_STOP}

var _game_paused = false

func set_time_scale(scale):
	Engine.time_scale = scale


func stop_time(duration : float = 99999.0):
	if duration <= 0:
		return
	
	get_tree().paused = true
	if duration == 99999:
		timer.stop()
	
	print_debug(timer.time_left)
	if timer.time_left < duration:
		timer.start(duration)


func resume_time():
	get_tree().paused = false
	timer.stop()


func pause_game():
	set_game_paused(true)

func resume_game():
	set_game_paused(false)

func set_game_paused(value):
	get_tree().paused = value
	if timer.time_left > 0:
		get_tree().paused = true
	
	_game_paused = value
	timer.paused = value
	emit_signal("paused_game", value)


func is_time_stopped():
	return get_tree().paused


func is_game_paused():
	return _game_paused


func _on_Timer_timeout():
	get_tree().paused = false
