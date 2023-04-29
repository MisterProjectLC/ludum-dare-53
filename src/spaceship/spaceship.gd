extends CharacterBody2D

signal on_screen_changed(on_screen : bool)

@export var ACCELERATION_STRENGTH = 25.0
@export var MAX_SPEED = 1000.0
@export var limit = 150000

@onready var Pointer = $%Pointer

var move_velocity  = Vector2.ZERO
var look_vector = Vector2.ZERO
var ori: Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalNode.connect("on_cutscene_changed", Callable(self, "on_cutscene_changed"))


func on_cutscene_changed(in_cutscene):
	if in_cutscene:
		move_velocity = Vector2.ZERO


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GlobalNode.get_in_cutscene():
		return
	
	manage_direction(delta)
	manager_acceleration(delta)


func manager_acceleration(delta):
	move_and_collide(move_velocity)
	if Input.is_action_pressed("accelerate"):
		move_velocity += look_vector*ACCELERATION_STRENGTH*delta
		if move_velocity.length() > MAX_SPEED:
			move_velocity = move_velocity.normalized()*MAX_SPEED
	
	if global_position.x > limit:
		global_position.x = -limit + 100
	if global_position.y > limit:
		global_position.y = -limit + 100
	if global_position.x < -limit:
		global_position.x = limit - 100
	if global_position.y < -limit:
		global_position.y = limit - 100


func manage_direction(_delta):
	if ControllerManager.is_controller_active():
		manage_direction_controller()
	else:
		manage_direction_mouse()
	
	Pointer.rotation = atan2(-look_vector.y, -look_vector.x)


func manage_direction_controller():
	var deadzone = 0.5
	var xAxisRL = Input.get_joy_axis(0, JoyAxis.JOY_AXIS_RIGHT_X)
	var yAxisUD = Input.get_joy_axis(0 , JoyAxis.JOY_AXIS_RIGHT_Y)
	
	if abs(xAxisRL) > deadzone || abs(yAxisUD) > deadzone:
		look_vector = Vector2(xAxisRL, yAxisUD)
	else:
		look_vector = ori
	look_vector = look_vector.normalized()


func manage_direction_mouse():
	look_vector = (get_global_mouse_position() - global_position).normalized()


func _on_visible_on_screen_notifier_2d_screen_entered():
	emit_signal("on_screen_changed", true)


func _on_visible_on_screen_notifier_2d_screen_exited():
	emit_signal("on_screen_changed", false)
