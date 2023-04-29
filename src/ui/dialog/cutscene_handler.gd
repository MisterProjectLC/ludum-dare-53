extends Control
class_name CutsceneHandler

signal events_ended()
signal animation_requested(animation, backwards)

@export var disable_cutscenes = false

var future_events = []
var voiceover_text = false
var custom
var waiting_animation = null

var current_scene = ""


func load_events(scene):
	current_scene = scene
	var filepath = ("text/" + scene)
	_internal_load_events(FileLoader.load_json(filepath))

func _internal_load_events(events):
	future_events = events
	run_next_event()


func run_next_event():
	if len(future_events) <= 0:
		return
	
	var next_event = future_events[0]
	future_events = future_events.slice(1, len(future_events))
	print_debug(next_event)
	run_event(next_event)


func run_event(event : Dictionary):
	if event.has("VOICEOVER"):
		play_voiceover(event)
	elif event.has("TEXT"):
		play_text(event)
	elif event.has("LIVE_TEXT"):
		play_live_text(event)
	elif event.has("APPEND_TEXT"):
		append_text(event)
	elif event.has("CLOSE_TEXT"):
		close_text(event)
	elif event.has("CHARACTER"):
		character(event)
	elif event.has("WAIT"):
		wait(event)
	elif event.has("ANIMATION"):
		play_animation(event)
	elif event.has("SAVE"):
		save(event)
	elif event.has("END"):
		end()


func play_text(_event):
	run_next_event()

func play_live_text(_event):
	run_next_event()

func append_text(_event):
	run_next_event()

func close_text(_event):
	run_next_event()

func character(_event):
	run_next_event()

func play_voiceover(_event):
	run_next_event()

func play_animation(_event):
	run_next_event()

func wait(_event):
	run_next_event()

func save(_event):
	run_next_event()

func end():
	emit_signal("events_ended")
