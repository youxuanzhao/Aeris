extends CollisionBlock

func type():
	return "Fire"

func _tick():
	# Check for water
	if len(get_neighborhoods_with_type("WaterFlow") + get_neighborhoods_with_type("WaterSource")) > 0:
		change_to("WaterVapor")