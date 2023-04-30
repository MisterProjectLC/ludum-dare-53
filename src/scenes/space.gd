extends Node2D

@onready var Planets = $Planets
@onready var Asteroids = $Asteroids
@onready var Station = $Station
@onready var Spaceship = $Spaceship
@onready var Camera = $CameraFollower
@onready var CutscenePlayer = $CanvasLayer/CutsceneController
@onready var DialogTimer = $DialogTimer
@onready var Animator = $AnimationPlayer
@onready var UI = $CanvasLayer/UI
@onready var Stars = $ParallaxBackground/StarsParallax

@export var space_dialogs : Array[String]
@export var items : Array[String]
var inventory = []

var on_planet = false
var planets_visited = 0
var space_dialog_index = 0
var game_stage = -1

@export var limit = 100000


# Called when the node enters the scene tree for the first time.
func _ready():
	for planet in Planets.get_children():
		planet.connect("spaceship_approached", Callable(self, "on_spaceship_approached_planet"))
	for asteroid in Asteroids.get_children():
		asteroid.connect("spaceship_approached", Callable(self, "on_spaceship_approached_asteroid"))
	
	Station.connect("spaceship_approached", Callable(self, "on_spaceship_approached_station"))
	Spaceship.limit = limit
	Camera.set_limit(limit)


func _process(_delta):
	Stars.modulate.a = clamp(GlobalNode.get_camera_zoom()*8, 0, 1)


func on_spaceship_approached_station(body):
	play_dialog(body.get_dialog_title())
	
	space_dialog_index += 1
	game_stage += 1
	if game_stage == 0:
		for asteroid in Asteroids.get_children():
			asteroid.set_active(true)
	
	if (game_stage+1)*3 > Planets.get_child_count():
		end_game()
	else:
		activate_planets()
	
	Station.set_active(false)
	on_planet = true


func on_spaceship_approached_planet(body):
	play_dialog(body.get_dialog_title())
	if planets_visited % 3 == 0:
		activate_station()
	
	planets_visited += 1
	space_dialog_index += 1
	on_planet = true


func on_spaceship_approached_asteroid(body):
	play_dialog(body.get_dialog_title())


func play_dialog(events):
	CutscenePlayer.load_events(events)


func end_game():
	pass


func _on_cutscene_controller_events_ended():
	if on_planet:
		on_planet = false
		DialogTimer.start()
		Spaceship.set_dash_enabled(false)
	
	else:
		Spaceship.set_dash_enabled(true)
		if game_stage == -1:
			activate_station()


func activate_planets():
	UI.set_objective("Deliver packages!")
	for i in range(game_stage*3, (game_stage+1)*3):
		Planets.get_child(i).set_active(true)
		var item = {"IMAGE": TextureLoader.get_tex_from_title(
		"items/" + items[i].to_lower()), "TITLE": items[i]}
		CutscenePlayer.add_item(item)
		inventory.append(item)
	UI.set_items(inventory)


func activate_station():
	UI.set_objective("Fly to the Post Office Station")
	Station.set_active(true)


func _on_dialog_timer_timeout():
	play_dialog(space_dialogs[space_dialog_index])


func _on_cutscene_controller_animation_requested(animation, backwards):
	if backwards:
		Animator.play_backwards(animation)
	else:
		Animator.play(animation)


func _on_animation_player_animation_finished(anim_name):
	CutscenePlayer.on_animation_finished(anim_name)


func _on_cutscene_controller_item_chosen(item):
	inventory.erase(item)
	UI.set_items(inventory)
