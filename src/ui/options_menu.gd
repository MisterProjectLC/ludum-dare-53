extends Control

signal back_pressed()

func _ready():
	$Sound.value = GlobalNode.sound_volume
	$Music.value = GlobalNode.music_volume

func _on_music_value_changed(value):
	GlobalNode.music_volume = $Music.value
	AudioServer.set_bus_volume_db(2, log(value) * 20)


func _on_sound_value_changed(value):
	GlobalNode.sound_volume = $Sound.value
	AudioServer.set_bus_volume_db(1, log(value) * 20)


func _on_back_button_up():
	emit_signal("back_pressed")
