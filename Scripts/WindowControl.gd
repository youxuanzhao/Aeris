extends Camera2D

const level_scale = 8 * 11

const level_views_size = [
	Vector2i(1, 1),
	Vector2i(2, 1),
	Vector2i(2, 2),
	Vector2i(3, 2),
	Vector2i(3, 3),
]

const level_views_offset = [
	Vector2i(1, 1),
	Vector2i(1, 1),
	Vector2i(1, 1),
	Vector2i(0, 1),
	Vector2i(0, 0),
]

var window_scale: float

var current_level = 0

func _ready():
	window_scale = DisplayServer.screen_get_size().y / 4.0
	print(scale)
	change_to_level(current_level)

func change_to_level(l: int):
	get_viewport().set_content_scale_size(level_views_size[l] * level_scale)
	position = level_views_offset[l] * (level_scale)
	get_window().max_size = level_views_size[l] * window_scale
	get_window().min_size = level_views_size[l] * window_scale
	get_window().size = level_views_size[l] * window_scale
	current_level = l



func _input(event):
	if event.is_action_pressed("test"):
		if current_level < level_views_size.size() - 1:
			current_level += 1
		else:
			current_level = 0
		change_to_level(current_level)
		
