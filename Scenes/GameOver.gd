extends Control

class_name GameOver

static var instance: GameOver

func fade_in():
	$AnimationPlayer.play("fade_in")	
	$"CanvasLayer/Panel".mouse_filter = MOUSE_FILTER_STOP
	await $AnimationPlayer.animation_finished
	set_children_mouse_filter($"CanvasLayer/Panel", MOUSE_FILTER_STOP)

func fade_out():
	$AnimationPlayer.play_backwards("fade_in")
	$"CanvasLayer/Panel".mouse_filter = MOUSE_FILTER_IGNORE
	set_children_mouse_filter($"CanvasLayer/Panel", MOUSE_FILTER_IGNORE)

func is_open():
	return $"CanvasLayer/Panel".mouse_filter == MOUSE_FILTER_STOP

func died():
	fade_in()

func win():
	$AnimationPlayer.play("win")

func undo():
	Player.instance.undo()
	TileManager.instance.undo()

	fade_out()


func set_children_mouse_filter(p, m: int):
	for c in p.get_children():
		if "mouse_filter" in c:
			c.mouse_filter = m

# Called when the node enters the scene tree for the first time.
func _ready():
	instance = self
	fade_out()
	$AnimationPlayer.seek(0)
	set_children_mouse_filter($CanvasLayer, MOUSE_FILTER_IGNORE)
	
	$"CanvasLayer/Panel/Undo".pressed.connect(undo)
