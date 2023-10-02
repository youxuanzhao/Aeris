extends BasicBlock

func _tick():
	if (not neighborhoods_has_type("Fire")) and has_air():
		# Resurrect
		print("Resurrecting")
		if lifespan == -1:
			lifespan = 3
	else:
		lifespan = -1

	super._tick()

func type():
	return "DeadTree"


func _dead():
	change_to("Tree")
