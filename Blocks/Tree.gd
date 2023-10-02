extends CollisionBlock

var has_triggered = false

func _tick():
	super._tick()
	if has_air():
		has_triggered = true
		for d in directions:
			var c = TileManager.instance.get_neighbor_cell(map_position(), d)
			if TileManager.instance.has_air(c) == false:
				TileManager.instance.instantiate_block(c,"FakeAir")
				TileManager.instance.set_air(c, true)
	if !has_air() && has_triggered:
		for d in directions:
			var c = TileManager.instance.get_neighbor_cell(map_position(), d)
			if TileManager.instance.get_block(c) != null:
				if TileManager.instance.get_block(c).type() == "FakeAir":
					TileManager.instance.get_block(c)._dead()
					TileManager.instance.set_air(c, false)

func type():
	return "Tree"
