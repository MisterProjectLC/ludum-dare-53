extends Control


var first_explanation = true
func _on_spaceship_dash_updated(fuel_value):
	$DashBar.value = fuel_value
	
	if fuel_value == 0:
		$DashExplanation.visible = false
	if first_explanation and $DashBar.value == $DashBar.max_value:
		$DashExplanation.visible = true
		first_explanation = false
