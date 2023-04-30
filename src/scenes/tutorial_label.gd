@tool
extends Label

@export var keyboard_text = ""
@export var controller_text = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	ControllerManager.connect("on_controller_changed", Callable(self, "update_controller"))


func _process(_delta):
	if Engine.is_editor_hint():
		text = keyboard_text


func update_controller(controller_active):
	text = controller_text if controller_active else keyboard_text
