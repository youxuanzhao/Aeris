extends CollisionBlock

func _ready():
	super._ready()
	lifespan = -1

func type():
	return "Fire"

func _tick():
	super._tick()
	if !has_air():
		change_to("FireSpark")
		return
	if neighborhoods_has_type("WaterFlow") or neighborhoods_has_type("WaterSource"):
		change_to("WaterVapor")
		
	for block in TileManager.instance.get_blocks(map_position()):
		if block.Burnate > 0:
			block._dead()

	for c in get_neighborhoods_coords():
		if TileManager.instance.has_air(c) and CoordinateBurnable(c) and !coordinate_has(c,"Fire"):
			TileManager.instance.instantiate_block(c, "Fire")
