extends Node

var windowSize : Vector2i

func _ready():
	windowSize = DisplayServer.screen_get_size()
	get_viewport().set_content_scale_size(Vector2i(80,80))
	get_window().size = Vector2i(windowSize.y/4, windowSize.y/4)

func _input(event):
	if event.is_action_pressed("test"):
		get_window().size = Vector2i(windowSize.y/2, windowSize.y/4)
		get_viewport().set_content_scale_size(Vector2i(160,80))
		
