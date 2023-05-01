extends Control
class_name Menu

var starting = false
var quitting = false

func _ready():
	Transitions.connect("transition_finished", Callable(self, "on_transition_finished"))


func _on_start_button_up():
	starting = true
	Transitions.play("BlackOut")

func on_transition_finished(_anim_name):
	if starting:
		get_tree().change_scene_to_file("res://src/scenes/space.tscn")
	elif quitting:
		get_tree().quit()


func _on_options_button_up():
	$AnimationPlayer.play("ShowOptions")


func _on_quit_button_up():
	quitting = true
	Transitions.play("BlackOut")


func _on_options_menu_back_pressed():
	$AnimationPlayer.play_backwards("ShowOptions")
