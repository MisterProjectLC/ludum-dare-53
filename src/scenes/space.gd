extends Node2D

@onready var Planets = $Planets
@onready var Cutscenes = $CanvasLayer/CutsceneController

# Called when the node enters the scene tree for the first time.
func _ready():
	for planet in Planets.get_children():
		planet.connect("spaceship_approached", Callable(self, "on_spaceship_approached_body"))

func on_spaceship_approached_body(body):
	play_dialog(body.get_dialog_title())


func play_dialog(events):
	Cutscenes.load_events(events)
