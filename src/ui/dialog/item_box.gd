extends ColorRect

signal on_clicked(index)

var item = {}
var hovered = false
var active = false
var index = 0

func get_item():
	return item


func setup(this_item):
	item = this_item
	$Image.texture = this_item["IMAGE"]
	$Label.text = this_item["TITLE"].capitalize()


func _input(event):
	if (hovered and active and event is InputEventMouseButton and 
			event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
		emit_signal("on_clicked", get_index())


func set_active(t):
	active = t


func _on_mouse_entered():
	hovered = true


func _on_mouse_exited():
	hovered = false
