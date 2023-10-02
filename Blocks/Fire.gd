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

	for c in get_neighborhoods_coords():
		if TileManager.instance.has_air(c) and not TileManager.instance.get_block(c):
			TileManager.instance.instantiate_block(c, "FireSpark")