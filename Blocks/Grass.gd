extends CollisionBlock

func type():
	return "Grass"

func can_grow(coordinate : Vector2i) -> bool:
	return (neighborhoods_has_type("WaterFlow",coordinate) || neighborhoods_has_type("WaterSource",coordinate)) && !neighborhoods_has_type("Fire") && !coord_has("WaterSource",coordinate) && !coord_has("Water",coordinate)

func _tick():
	if !can_grow(map_position()):
		_dead()
		return
	for coordinate in get_neighborhoods_coords():
		if !coord_has("Grass",coordinate) && can_grow(coordinate):
			TileManager.instance.instantiate_block(coordinate,"Grass")
