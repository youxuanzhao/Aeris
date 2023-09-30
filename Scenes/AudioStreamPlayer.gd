extends AudioStreamPlayer

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

var walk = AudioStreamRandomizer.new()
var collide = AudioStreamRandomizer.new()

func _ready():
	for s in walk_effects:
		walk.add_stream(0, s)
	
	for s in collide_effects:
		collide.add_stream(0, s)

func play_audio(audio: String):
	if audio == "walk":
		stream = walk
	if audio == "collide":
		stream = collide
		
	play()
