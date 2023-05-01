extends Menu

var leaving = false


func on_transition_finished(_anim_name):
	if leaving:
		get_tree().change_scene_to_file("res://src/ui/main_menu.tscn")


func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_pause()


func toggle_pause():
	get_tree().paused = !get_tree().paused
	if get_tree().paused:
		#Input.set_custom_mouse_cursor(GlobalNode.menu_mouse)
		$PauseAnimations.play("Blackout")
	else:
		#Input.set_custom_mouse_cursor(GlobalNode.game_mouse)
		$PauseAnimations.play_backwards("Blackout")


func _on_back_button_up():
	toggle_pause()


func _on_main_menu_button_up():
	leaving = true
	get_tree().paused = false
	Transitions.play("BlackOut")
