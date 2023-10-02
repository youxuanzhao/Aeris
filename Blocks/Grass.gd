extends CollisionBlock

func type():
	return "Grass"

func can_grow(coordinate : Vector2i) -> bool:
	
	return (neighborhoods_has_type("WaterFlow",coordinate) || neighborhoods_has_type("WaterSource",coordinate)) && !neighborhoods_has_type("Fire")

func _tick():
	if !can_grow(map_position()):
		_dead()
		return
	for coordinate in get_neighborhoods_coords():
		if not TileManager.instance.get_block(coordinate) and can_grow(coordinate):
			TileManager.instance.instantiate_block(coordinate,"Grass")
