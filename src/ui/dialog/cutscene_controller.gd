extends CutsceneHandler
class_name CutsceneController

signal item_chosen(item, was_correct)

@export var voices : Dictionary

@onready var dialog : Dialog = $Dialog
@onready var waitObj = $Wait
@onready var voiceover = $VoiceoverPlayer
@onready var Inventory = $Inventory

var stored_events = []
var stored_character = ""

var waiting_choice = false
var choice_events = []

var is_without_scarf = false

func _ready():
	TimeController.connect("paused_game", Callable(self, "on_paused_game"))


func load_events(scene):
	waitObj.stop()
	voiceover.stop()
	dialog.stop()
	stored_character = current_character
	stored_events = future_events
	future_events = []
	super.load_events(scene)


func play_text(event):
	GlobalNode.set_in_cutscene(true)
	if event.has("TIME"):
		if event.has("AUTOSKIP"):
			dialog.add_text(event["TEXT"], event["TIME"], event["AUTOSKIP"])
		else:
			dialog.add_text(event["TEXT"], event["TIME"])
	elif event.has("NARRATOR"):
		dialog.add_narrator_text(event["TEXT"])
	else:
		dialog.add_text(event["TEXT"])


func play_live_text(event):
	GlobalNode.set_in_cutscene(false)
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
	current_character = event["CHARACTER"]
	if is_without_scarf and event["CHARACTER"] == "Protagonist":
		dialog.change_character("protagonist_no_scarf")
	else:
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


func choice(event):
	waiting_choice = true
	choice_events = event["CHOICE"]
	Inventory.show_items()


func add_item(item):
	Inventory.add_item(item)


func stop():
	end()


func end():
	if stored_events == []:
		future_events = []
		dialog.end()
		GlobalNode.set_in_cutscene(false)
		super.end()
	else:
		future_events = stored_events
		current_character = stored_character
		future_events.push_front({"CHARACTER":stored_character})
		if stored_character == "Radio":
			future_events.push_front({"LIVE_TEXT":"And we're back to our programming..."})
		else:
			future_events.push_front({"LIVE_TEXT":"Uh, so what I was saying was..."})



# SIGNAL RESPONSES --------------------------------

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
	
	if !waiting_choice and waiting_animation == null:
		run_next_event()


func _on_inventory_item_chosen(item):
	waiting_choice = false
	var title = item["TITLE"]
	
	var correct = (title in choice_events)
	if correct:
		load_events(current_scene + "_" + title.to_lower())
	else:
		load_events(current_scene + "_" + "wrong")
	choice_events = []
	stored_events = []
	emit_signal("item_chosen", item, correct)
