extends Button

func set_children_mouse_filter(p: Panel, m: int):
	for c in p.get_children():
		if "mouse_filter" in c:
			c.mouse_filter = m

func _ready():
	set_children_mouse_filter($"../Panel" as Panel, MOUSE_FILTER_IGNORE)

func _pressed():
	var anim = $"../AnimationPlayer" as AnimationPlayer
	var panel = $"../Panel" as Panel
	if panel.mouse_filter == MOUSE_FILTER_IGNORE:
		anim.play("fade_in")
		await anim.animation_finished
		panel.mouse_filter = MOUSE_FILTER_STOP
		set_children_mouse_filter(panel, MOUSE_FILTER_STOP)
	else:
		anim.play_backwards("fade_in")
		await anim.animation_finished
		panel.mouse_filter = MOUSE_FILTER_IGNORE
		set_children_mouse_filter(panel, MOUSE_FILTER_IGNORE)
