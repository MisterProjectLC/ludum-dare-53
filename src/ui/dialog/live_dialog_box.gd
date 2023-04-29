extends DialogBox

signal dialog_finished()

@onready var end_timer = $EndTimer

func _on_Timer_timeout():
	label.visible_characters += 1
	if label.visible_characters < label.text.length():
		timer.start(current_char_time)
	
	else:
		end_timer.start(1)


func _on_EndTimer_timeout():
	emit_signal("dialog_finished")
