extends CollisionBlock

class_name WaterSource

func type():
	return "WaterSource"
	
static func CoordinateFlowable(c:Vector2i) -> bool:
	for block in TileManager.instance.get_blocks(c):
		if block.Block:
			return false
	return true
	
static func SinkCoordinate(c:Vector2i):
	for block in TileManager.instance.get_blocks(c):
		if block.Sink:
			block._dead()

static func expand(pos):
	# Check nearby empty blocks
	for d in directions:
		var c = TileManager.instance.get_neighbor_cell(pos, d)
		if TileManager.instance.has_air(c) and CoordinateFlowable(c):
			TileManager.instance.instantiate_block(c, "WaterFlow")
			SinkCoordinate(c)

func update_distance():
	var neighborhoods = get_neighborhoods_with_type("WaterFlow")
	var next_neighborhoods = []
	var searched = []
	var i = 1
	while len(neighborhoods) > 0:
		for n in neighborhoods:
			(n as WaterFlow).set_distance_to_water(i)
			searched.append(n.map_position())
			for nn in n.get_neighborhoods_with_type("WaterFlow"):
				if nn.map_position() not in searched:
					next_neighborhoods.append(nn)

		print(len(neighborhoods))
		neighborhoods = next_neighborhoods
		next_neighborhoods = []
		i += 1

func _tick():
	update_distance()
	WaterSource.expand(map_position())
