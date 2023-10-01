extends AudioStreamPlayer

class_name SoundEffects

const walk_effects = [
	preload("res://Assets/Sounds/walk-1.wav"),
	preload("res://Assets/Sounds/walk-2.wav"),
	preload("res://Assets/Sounds/walk-3.wav"),
]

const collide_effects = [
	preload("res://Assets/Sounds/collide-1.wav"),
	preload("res://Assets/Sounds/collide-2.wav"),
	preload("res://Assets/Sounds/collide-3.wav"),
]

const up_effects = [
	preload("res://Assets/Sounds/up-1.wav"),
	preload("res://Assets/Sounds/up-2.wav"),
	preload("res://Assets/Sounds/up-3.wav"),
]

const down_effects = [
	preload("res://Assets/Sounds/down-1.wav"),
	preload("res://Assets/Sounds/down-2.wav"),
	preload("res://Assets/Sounds/down-3.wav"),
]

var walk = AudioStreamRandomizer.new()
var collide = AudioStreamRandomizer.new()
var up = AudioStreamRandomizer.new()
var down = AudioStreamRandomizer.new()

func _ready():
	for s in walk_effects:
		walk.add_stream(0, s)

	for s in collide_effects:
		collide.add_stream(0, s)

	for s in up_effects:
		up.add_stream(0, s)
	
	for s in down_effects:
		down.add_stream(0, s)

func play_audio(audio: String):
	volume_db = 0
	if audio == "walk":
		stream = walk
	if audio == "collide":
		# Lower the volume of the collide sound
		volume_db = -10
		stream = collide
	if audio == "up":
		stream = up
	if audio == "down":
		stream = down

	play()
