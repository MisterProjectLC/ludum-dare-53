extends Node2D

@onready var Planets = $Planets
@onready var Station = $Station
@onready var CutscenePlayer = $CanvasLayer/CutsceneController
@onready var DialogTimer = $DialogTimer

@export var space_dialogs : Array[String]

var on_planet = false
var planets_visited = 0
var space_dialog_index = 0
var game_stage = -1


# Called when the node enters the scene tree for the first time.
func _ready():
	for planet in Planets.get_children():
		planet.connect("spaceship_approached", Callable(self, "on_spaceship_approached_planet"))
	Station.connect("spaceship_approached", Callable(self, "on_spaceship_approached_station"))


func on_spaceship_approached_station(body):
	play_dialog(body.get_dialog_title())
	
	space_dialog_index += 1
	game_stage += 1
	if (game_stage+1)*3 > Planets.get_child_count():
		end_game()
	else:
		for i in range(game_stage*3, (game_stage+1)*3):
			Planets.get_child(i).set_active(true)
	
	Station.set_active(false)
	on_planet = true


func on_spaceship_approached_planet(body):
	play_dialog(body.get_dialog_title())
	if planets_visited % 3 == 0:
		Station.set_active(true)
	planets_visited += 1
	space_dialog_index += 1
	on_planet = true


func play_dialog(events):
	CutscenePlayer.load_events(events)


func end_game():
	pass


func _on_cutscene_controller_events_ended():
	if on_planet:
		on_planet = false
		DialogTimer.start()
	elif game_stage == -1:
		Station.set_active(true)


func _on_dialog_timer_timeout():
	play_dialog(space_dialogs[space_dialog_index])


func _on_cutscene_controller_animation_requested(animation, _backwards):
	print_debug(animation)
