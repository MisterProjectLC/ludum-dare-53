extends Control

signal back_pressed()


func _ready():
	$Sound.value = AudioServer.get_bus_volume_db(1)
	$Music.value = AudioServer.get_bus_volume_db(2)

func _on_music_value_changed(value):
	AudioServer.set_bus_volume_db(2, value)


func _on_sound_value_changed(value):
	AudioServer.set_bus_volume_db(1, value )


func _on_back_button_up():
	emit_signal("back_pressed")
