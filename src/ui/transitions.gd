extends Control

@onready var Animator = $AnimationPlayer

signal transition_finished(transition)

var anim

func play(anim_name):
	Animator.play("Reset")
	anim = anim_name


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Reset":
		Animator.play(anim)
	else:
		emit_signal("transition_finished", anim_name)
		if anim_name == "CloseFromLeft":
			Animator.play("OpenFromRight")
		elif anim_name == "BlackOut":
			Animator.play("BlackIn")
