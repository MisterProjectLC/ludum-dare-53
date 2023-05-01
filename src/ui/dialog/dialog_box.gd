extends Control
class_name DialogBox

@onready var current_char_time = 0.1

@onready var rect = $Rect
@onready var portrait : TextureRect = $Rect/Portrait
@onready var label = $Rect/Label
@onready var animator = $Rect/AnimationPlayer

@onready var timer = $Rect/Timer

var autoskip = false

func appear():
	animator.play("Appear")

func fade():
	animator.play("Fade")

func disappear():
	rect.visible = false


func write(text, time):
	label.text = text
	label.visible_characters = 0
	_show_text(time)


func append(text, time):
	label.visible_characters = label.text.length()
	label.text += text
	_show_text(time)


func change_character(character):
	portrait.texture = TextureLoader.get_tex_from_title(
		"characters/" + character.to_lower())


func set_font(font):
	label.set("theme_override_fonts/font", font)


func _show_text(time):
	current_char_time = time
	timer.start(time)


func _on_Timer_timeout():
	label.visible_characters += 1
	if label.visible_characters < label.text.length():
		timer.start(current_char_time)
	elif autoskip:
		emit_signal("dialog_finished")


func is_active():
	return $Rect.visible
