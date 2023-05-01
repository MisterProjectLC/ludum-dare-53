extends Node2D

@onready var Cycles = $Cycles
@onready var Asteroids = $Asteroids
@onready var Station = $Station
@onready var Spaceship = $Spaceship
@onready var PlanetX = $PlanetX
@onready var Camera = $CameraFollower
@onready var CutscenePlayer = $CanvasLayer/CutsceneController
@onready var DialogTimer = $DialogTimer
@onready var Animator = $AnimationPlayer
@onready var UI = $CanvasLayer/UI
@onready var Stars = $ParallaxBackground/StarsParallax

@export var space_dialogs : Array[String]
@export var station_dialogs : Array[String]
@export var items : Array[String]
var inventory = []

var on_planet = false
var planets_visited = 0
var planets_on_cycle_visited = 0
var space_dialog_index = 0
var game_stage = -1
enum STAGE {PREGAME = -1, CYCLE1, CYCLE2, CYCLE3, ENDING}


@export var limit = 100000


# Called when the node enters the scene tree for the first time.
func _ready():
	for cycle in Cycles.get_children():
		for planet in cycle.get_children():
			planet.connect("spaceship_approached", Callable(self, "on_spaceship_approached_planet"))
	for asteroid in Asteroids.get_children():
		asteroid.connect("spaceship_approached", Callable(self, "on_spaceship_approached_asteroid"))
	PlanetX.connect("spaceship_approached", Callable(self, "on_spaceship_approached_planetx"))
	
	Station.connect("spaceship_approached", Callable(self, "on_spaceship_approached_station"))
	Spaceship.limit = limit
	Camera.set_limit(limit)


func _process(_delta):
	Stars.modulate.a = clamp(GlobalNode.get_camera_zoom(), 0, 1)


func on_spaceship_approached_station(body):
	play_dialog(body.get_dialog_title())
	
	space_dialog_index += 1
	game_stage += 1
	planets_on_cycle_visited = 0
	
	match(game_stage):
		STAGE.CYCLE1:
			for asteroid in Asteroids.get_children():
				asteroid.set_active(true)
		STAGE.CYCLE2:
			PlanetX.set_active(true)
	
	
	if (game_stage+1) <= Cycles.get_child_count():
		activate_planets()
	
	Station.set_active(false)
	on_planet = true


func on_spaceship_approached_planet(body):
	play_dialog(body.get_dialog_title())
	planets_visited += 1
	
	planets_on_cycle_visited += 1
	if planets_on_cycle_visited >= get_planet_cycle(game_stage).get_child_count():
		activate_station()
	
	space_dialog_index += 1
	on_planet = true


func on_spaceship_approached_planetx(body):
	play_dialog(body.get_dialog_title())
	space_dialog_index += 1
	replace_space_dialog("companion8", "companion9")
	replace_space_dialog("companion7", "companion8")
	on_planet = true


func on_spaceship_approached_asteroid(body):
	play_dialog(body.get_dialog_title())


func _on_cutscene_controller_item_chosen(item, correct):
	inventory.erase(item)
	UI.set_items(inventory)
	if correct:
		if item["TITLE"].to_lower() == "feather":
			replace_space_dialog("radio2", "radio2_right")


func end_game():
	get_tree().change_scene_to_file("res://src/ui/main_menu.tscn")


func leave_planet():
	on_planet = false
	DialogTimer.start()
	Spaceship.set_dash_enabled(false)


func ended_space_dialog():
	Spaceship.set_dash_enabled(true)
	if game_stage == -1:
		activate_station()


func activate_planets():
	UI.set_objective("Deliver packages!")
	var cycle = Cycles.get_child(game_stage)
	for i in range(cycle.get_child_count()):
		cycle.get_child(i).set_active(true)
			
		var planet_index = planets_visited + i
		var item = {"IMAGE": TextureLoader.get_tex_from_title(
		"items/" + items[planet_index].to_lower()), "TITLE": items[planet_index]}
		CutscenePlayer.add_item(item)
		inventory.append(item)
	UI.set_items(inventory)


func activate_station():
	UI.set_objective("Fly to the Post Office Station")
	if game_stage != -1:
		Station.set_dialog_title(station_dialogs[game_stage])
	Station.set_active(true)


# HELPERS AND REACTIONS -----------------------

func replace_space_dialog(old, new):
	space_dialogs[space_dialogs.find(old)] = new

func get_planet_cycle(i):
	return Cycles.get_child(i)

func play_dialog(events):
	CutscenePlayer.load_events(events)


func _on_dialog_timer_timeout():
	play_dialog(space_dialogs[space_dialog_index])


func _on_cutscene_controller_events_ended():
	if game_stage == 3: # end game
		end_game()
	
	elif on_planet: # Finished planet
		leave_planet()
	
	else:
		ended_space_dialog()


func _on_cutscene_controller_animation_requested(animation, backwards):
	if backwards:
		Animator.play_backwards(animation)
	else:
		Animator.play(animation)


func _on_animation_player_animation_finished(anim_name):
	CutscenePlayer.on_animation_finished(anim_name)
