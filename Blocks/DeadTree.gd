extends BasicBlock

func _tick():
	if neighborhoods_has_type("Fire") and has_air():
		# Resurrect
		if lifespan == -1:
			lifespan = 3
	else:
		lifespan = -1

func type():
	return "DeadTree"


func _dead():
	change_to("Tree")
