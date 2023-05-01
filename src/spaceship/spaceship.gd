extends CharacterBody2D

signal on_screen_changed(on_screen : bool)
signal dash_updated(fuel_value)

@export var ACCELERATION_STRENGTH = 25.0
@export var MAX_SPEED = 1000.0
@export var FUEL_TO_DASH = 4
@export var DASH_SPEED = 200.0
var limit = 150000

@export var hugo_sprite : Texture
@export var without_scarf_sprite : Texture

@onready var Pointer = $%Pointer
@onready var SmokeAnimation = $%SmokeAnimation

var move_velocity  = Vector2.ZERO
var look_vector = Vector2.ZERO
var ori: Vector2

var fuel = 0
var dash_enabled = false

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
	manage_fuel(delta)
	manager_acceleration(delta)


func manage_fuel(delta):
	if !dash_enabled:
		return
	
	if fuel < FUEL_TO_DASH:
		fuel += delta
		emit_signal("dash_updated", fuel)
	
	if Input.is_action_just_pressed("dash"):
		if fuel >= FUEL_TO_DASH:
			move_velocity += look_vector*DASH_SPEED
		fuel = 0
		emit_signal("dash_updated", fuel)


func manager_acceleration(delta):
	move_and_collide(move_velocity)
	
	if Input.is_action_pressed("accelerate"):
		move_velocity += look_vector*ACCELERATION_STRENGTH*delta
		SmokeAnimation.play("Smoke")
	else:
		SmokeAnimation.stop()
		$Sprite/SmokeCloud.visible = false
	
	if move_velocity.length() > MAX_SPEED:
		move_velocity = lerp(move_velocity, move_velocity.normalized()*MAX_SPEED, 0.75)
	
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
	$Sprite.scale.x = 1 if look_vector.dot(Vector2.RIGHT) > 0 else -1


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


func hugo_popup():
	$Sprite.texture = hugo_sprite

func lose_scarf():
	$Sprite.texture = without_scarf_sprite


func set_dash_enabled(d):
	dash_enabled = d
	if !dash_enabled:
		fuel = 0
		emit_signal("dash_updated", 0)


func _on_visible_on_screen_notifier_2d_screen_entered():
	emit_signal("on_screen_changed", true)


func _on_visible_on_screen_notifier_2d_screen_exited():
	emit_signal("on_screen_changed", false)
