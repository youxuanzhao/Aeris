extends Control

class_name StartScreen


# Called when the node enters the scene tree for the first time.
func _ready():
	get_window().size = Vector2i(DisplayServer.screen_get_size().y/4.0,DisplayServer.screen_get_size().y/4.0)
	$"Splash/TextureRect"
	var anim = $AnimationPlayer
	anim.play_backwards("fade_in")
	
