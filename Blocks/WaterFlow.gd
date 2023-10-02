extends BasicBlock

class_name WaterFlow

const max_distance = 15

var distance_to_water = 0

func set_distance_to_water(distance):
	if distance < distance_to_water or distance_to_water == -1:
		distance_to_water = distance

func type():
	return "WaterFlow"


func _before_tick():
	distance_to_water = -1

func _tick():
	if not has_air():
		super._dead()
	
	if distance_to_water != -1:
		if distance_to_water == 1:
			lifespan = 2 # Work around
		else:
			lifespan = distance_to_water 
		if distance_to_water <= max_distance:
			WaterSource.expand(map_position())

	if len(get_neighborhoods_with_type("Fire")) > 0:
		change_to("WaterVapor")

	super._tick()


