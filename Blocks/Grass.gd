extends CollisionBlock

func type():
	return "Grass"

func _tick():
	for coordinate in get_neighborhoods_coords():
		if !coord_has("Grass",coordinate):
			TileManager.instance.instantiate_block(coordinate,"Grass")
