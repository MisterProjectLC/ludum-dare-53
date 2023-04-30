extends Control

signal item_chosen(title)

@export var items_path : NodePath
@onready var items_parent = get_node(items_path)

@onready var Animator = $AnimationPlayer

var items = []

const ITEM_ANIMATIONS = ["OneItem", "TwoItems", "ThreeItems"]


func add_item(item):
	items.append(item)


func show_items():
	for i in range(min(3, len(items))):
		items_parent.get_child(i).setup(items[i])
		items_parent.get_child(i).set_active(true)
	Animator.play(ITEM_ANIMATIONS[len(items)-1])


func _on_item_clicked(index):
	for i in range(min(3, len(items))):
		items_parent.get_child(i).set_active(false)
	Animator.play_backwards(ITEM_ANIMATIONS[len(items)-1])
	
	items.remove_at(index)
	emit_signal("item_chosen", items_parent.get_child(index).get_item())
