extends CollisionBlock

func type():
	return "FireSpark"

func _tick():
	super._tick()
	if has_air():
		change_to("Fire")
