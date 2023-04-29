extends DialogBox

signal dialog_finished()

@onready var press_timer = $PressTimer
var awaiting_input = true

func _input(event):
	if awaiting_input and event.is_action_pressed("ui_accept") and is_active():
		awaiting_input = false
		press_timer.start()
		
		if label.visible_characters >= label.text.length():
			emit_signal("dialog_finished")
		else:
			label.visible_characters = label.text.length()


func _on_press_timer_timeout():
	awaiting_input = true
