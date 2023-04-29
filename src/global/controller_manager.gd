extends Node

signal on_controller_changed(value)

var controller_active = false

const joy_button_names = {JOY_BUTTON_INVALID:"Invalid",
JOY_BUTTON_A:"Cross", JOY_BUTTON_Y:"Triangle",
JOY_BUTTON_B:"Circle", JOY_BUTTON_X:"Square", 
JOY_BUTTON_START:"Start", JOY_BUTTON_BACK:"Select",
JOY_BUTTON_LEFT_STICK:"L3", JOY_BUTTON_RIGHT_STICK:"R3",
JOY_BUTTON_LEFT_SHOULDER:"L1", JOY_BUTTON_RIGHT_SHOULDER:"R1",
JOY_BUTTON_DPAD_UP :"Up", JOY_BUTTON_DPAD_DOWN:"Down",
JOY_BUTTON_DPAD_LEFT:"Left", JOY_BUTTON_DPAD_RIGHT:"Right",}

const joy_axis_names = {JOY_AXIS_INVALID :"Invalid",
JOY_AXIS_LEFT_X :"Left X", JOY_AXIS_LEFT_Y :"Left Y",
JOY_AXIS_TRIGGER_LEFT :"L2", JOY_AXIS_TRIGGER_RIGHT:"R2"}


func get_joy_button_name(button):
	return (joy_button_names[button] 
	if joy_button_names.has(button) else "Invalid")

func get_joy_axis_name(button):
	return (joy_axis_names[button] 
	if joy_axis_names.has(button) else "Invalid")


func is_controller_active():
	return controller_active


func vibrate_controller(duration = 1, subtle_strength = 1, violent_strength = 0):
	if is_controller_active():
		Input.start_joy_vibration(0, subtle_strength, violent_strength, duration)

func _ready():
	if len(Input.get_connected_joypads()) > 0:
		controller_active = true


func _process(_delta):
	if Input.is_action_just_pressed("keyboard_detector"):
		if controller_active:
			controller_active = false
			emit_signal("on_controller_changed", false)
	elif Input.is_action_just_pressed("controller_detector"):
		if !controller_active:
			controller_active = true
			emit_signal("on_controller_changed", true)
