extends Node
class_name Utility

enum {
	UP = 0,
	LEFT,
	DOWN,
	RIGHT
}

#(Un)pauses a single node
static func set_freeze_node(node : Node, pause : bool) -> void:
	node.set_process(!pause)
	node.set_process_input(!pause)
	node.set_physics_process(!pause)
	node.set_process_unhandled_input(!pause)
	node.set_process_unhandled_key_input(!pause)

#(Un)pauses a scene
#Ignored childs is an optional argument, that contains the path of nodes whose state must not be altered by the function
static func set_freeze_scene(rootNode : Node, pause : bool, ignoredChilds : PackedStringArray = [null]):
	set_freeze_node(rootNode, pause)
	for node in rootNode.get_children():
		if not (String(node.get_path()) in ignoredChilds):
			set_freeze_scene(node, pause, ignoredChilds)


static func is_instance_freed(instance : Object):
	return instance == null or !weakref(instance).get_ref()


static func object_has_signal( object: Object, signal_name: String ) -> bool:
	var list = object.get_signal_list()
	
	for signal_entry in list:
		if signal_entry["name"] == signal_name:
			return true
		
	return false


static func get_cardinal_direction(direction):
	var highest_dot = direction.dot(Vector2.UP)
	var most_aligned = UP
	
	var this_dot = direction.dot(Vector2.LEFT)
	if this_dot > highest_dot:
		highest_dot = this_dot
		most_aligned = LEFT
	
	this_dot = direction.dot(Vector2.DOWN)
	if this_dot > highest_dot:
		highest_dot = this_dot
		most_aligned = DOWN
	
	this_dot = direction.dot(Vector2.RIGHT)
	if this_dot > highest_dot:
		most_aligned = RIGHT
	
	return most_aligned
