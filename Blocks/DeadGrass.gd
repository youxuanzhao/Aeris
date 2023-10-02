extends GrassBlock

func type():
	return "DeadGrass"
	
func _tick():
	if can_grow(map_position()):
		change_to("Grass")
