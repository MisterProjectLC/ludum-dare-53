extends Control

@onready var ItemContainer = $%ItemContainer
@onready var Animator = $ItemUI/AnimationPlayer

var first_explanation = true
func _on_spaceship_dash_updated(fuel_value):
	$DashBar.value = fuel_value
	
	if fuel_value == 0:
		$DashExplanation.visible = false
	if first_explanation and $DashBar.value == $DashBar.max_value:
		$DashExplanation.visible = true
		first_explanation = false


func set_objective(text):
	$CurrentObjective.text = text


func set_items(items):
	if len(items) == 0:
		if $ItemUI.visible:
			Animator.play_backwards("Show")
		return
	if !$ItemUI.visible:
		Animator.play("Show")
	
	for i in range(3):
		if len(items) > i:
			ItemContainer.get_child(i).visible = true
			ItemContainer.get_child(i).setup(items[i])
		else:
			ItemContainer.get_child(i).visible = false
