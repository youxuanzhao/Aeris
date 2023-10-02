extends CollisionBlock
class_name GrassBlock

func type():
	return "Grass"

func define_property():
	Sink = true
	Burnate = 2
	

func can_grow(coordinate : Vector2i) -> bool:
	
	return (neighborhoods_has_type("WaterFlow",coordinate,true) || neighborhoods_has_type("WaterSource",coordinate,true)) && !neighborhoods_has_type("Fire",coordinate,true)

func _tick():
	if !can_grow(map_position()):
		change_to("DeadGrass")
		return
	for coordinate in get_neighborhoods_coords(map_position(),true):
		if not TileManager.instance.get_block(coordinate) and can_grow(coordinate):
			TileManager.instance.instantiate_block(coordinate,"Grass")
