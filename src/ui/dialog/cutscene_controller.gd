extends CutsceneHandler
class_name CutsceneController

@export var voices : Dictionary

@onready var dialog : Dialog = $Dialog
@onready var waitObj = $Wait
@onready var voiceover = $VoiceoverPlayer


func _ready():
	TimeController.connect("paused_game", Callable(self, "on_paused_game"))


func load_events(scene):
	waitObj.stop()
	voiceover.stop()
	dialog.stop()
	future_events = []
	super.load_events(scene)


func play_text(event):
	if event.has("TIME"):
		dialog.add_text(event["TEXT"], event["TIME"])
	else:
		dialog.add_text(event["TEXT"])

func play_live_text(event):
	if event.has("TIME"):
		dialog.add_live_text(event["LIVE_TEXT"], event["TIME"])
	else:
		dialog.add_live_text(event["LIVE_TEXT"])


func append_text(event):
	if event.has("TIME"):
		dialog.append_text(event["APPEND_TEXT"], event["TIME"])
	else:
		dialog.append_text(event["APPEND_TEXT"])

func close_text(_event):
	dialog.stop()
	run_next_event()

func character(event):
	dialog.change_character(event["CHARACTER"])

func play_voiceover(event):
	voiceover.play_stream(voices[event["VOICEOVER"]])
	
	if event.has("TEXT"): 
		voiceover_text = true
		play_text(event)
	elif event.has("LIVE_TEXT"):
		play_live_text(event)
	elif event.has("APPEND_TEXT"):
		append_text(event)


func play_animation(event):
	if event.has("BACKWARDS"):
		emit_signal("animation_requested", event["ANIMATION"], event["BACKWARDS"])
	else:
		emit_signal("animation_requested", event["ANIMATION"], false)
	
	if !event.has("REQUIRED") or !event["REQUIRED"]:
		GlobalNode.set_in_cutscene(false)
		run_next_event()
	else:
		GlobalNode.set_in_cutscene(true)
		waiting_animation = event["ANIMATION"]


func wait(event):
	GlobalNode.set_in_cutscene(event.has("REQUIRED") and event["REQUIRED"])
	waitObj.start(event["WAIT"])

func save(_event):
	run_next_event()


func stop():
	end()


func end():
	future_events = []
	dialog.end()
	GlobalNode.set_in_cutscene(false)
	super.end()


func _on_Wait_timeout():
	run_next_event()


func on_animation_finished(anim_name):
	if waiting_animation == anim_name:
		waiting_animation = null
		run_next_event()


func on_paused_game(paused):
	dialog.process_mode = Node.PROCESS_MODE_PAUSABLE if paused else Node.PROCESS_MODE_ALWAYS
	voiceover.set_stream_paused(paused)

func _on_dialog_dialog_finished():
	if voiceover_text:
		voiceover_text = false
		voiceover.stop()
	
	if waiting_animation == null:
		run_next_event()


func _on_CodexReader_event_played(event):
	run_event(event)


func _on_CodexReader_events_ended():
	end()
