extends Control
class_name Dialog

signal dialog_finished()

@export var default_font : FontFile
@export var narrator_font : FontFile

@export var default_char_time = 0.05

@onready var cutscene_dialog_box = $CutsceneDialogBox
@onready var live_dialog_box = $LiveDialogBox
var current_box : DialogBox = null



func change_character(character):
	cutscene_dialog_box.change_character(character)
	live_dialog_box.change_character(character)
	emit_signal("dialog_finished")


func add_text(text, time = default_char_time):
	_switch_box(cutscene_dialog_box)
	cutscene_dialog_box.set_font(default_font)
	_start_text(text, time)


func add_narrator_text(text, time = default_char_time):
	_switch_box(cutscene_dialog_box)
	cutscene_dialog_box.set_font(narrator_font)
	_start_text(text, time)


func add_live_text(text, time = default_char_time):
	_switch_box(live_dialog_box)
	_start_text(text, time)


func _switch_box(new_box):
	if current_box == new_box:
		return
	
	if current_box != null:
		if current_box == live_dialog_box and new_box == null:
			current_box.fade()
		else:
			current_box.disappear()
	
	current_box = new_box
	if new_box != null:
		new_box.appear()


func _start_text(text, time = default_char_time):
	current_box.write(text, time)


func append_text(text, time = default_char_time):
	current_box.append(text, time)


func end():
	stop()
	emit_signal("dialog_finished")


func stop():
	_switch_box(null)


func _on_dialog_finished():
	if current_box != null:
		emit_signal("dialog_finished")
