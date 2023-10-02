extends CollisionBlock

var activate = false

func _tick():
	super._tick()
	if not has_air() and activate:
		# Clean up
		for d in directions:
			var c = TileManager.instance.get_neighbor_cell(map_position(), d)
			TileManager.instance.set_fake_air(c, false)

	activate = has_air()

	if activate:
		for d in directions:
			var c = TileManager.instance.get_neighbor_cell(map_position(), d)
			TileManager.instance.set_fake_air(c, true)

func type():
	return "Tree"