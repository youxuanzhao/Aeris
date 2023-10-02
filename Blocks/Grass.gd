extends CollisionBlock

func type():
	return "Grass"

func _tick():
	if len(get_neighborhoods_with_type("WaterFlow") + get_neighborhoods_with_type("WaterSource")) > 0:
		change_to("WaterVapor")
