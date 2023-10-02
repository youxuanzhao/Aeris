extends CollisionBlock

var activate = false

func define_property():
	Block = true

func clean_up():
	for d in directions:
		var c = TileManager.instance.get_neighbor_cell(map_position(), d)
		TileManager.instance.set_fake_air(c, false)

func _tick():
	super._tick()
	if not has_air() and activate:
		clean_up()

	activate = has_air()

	if activate:
		for d in directions:
			var c = TileManager.instance.get_neighbor_cell(map_position(), d)
			TileManager.instance.set_fake_air(c, true)
	
	if len(get_neighborhoods_with_type("Fire")) > 0:
		change_to("DeadTree")
		if activate:
			clean_up()

func type():
	return "Tree"
