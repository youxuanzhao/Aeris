extends Control

class_name StartScreen

const window_scale = 3.3

# Called when the node enters the scene tree for the first time.
func _ready():
	get_window().size = Vector2i(DisplayServer.screen_get_size().y/window_scale,DisplayServer.screen_get_size().y/window_scale)
	$"Splash/TextureRect"
	var anim = $AnimationPlayer
	anim.play_backwards("fade_in")
	
