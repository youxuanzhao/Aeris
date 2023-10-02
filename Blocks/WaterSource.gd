extends CollisionBlock

class_name WaterSource

func type():
	return "WaterSource"

static func expand(pos):
	# Check nearby empty blocks
	for d in directions:
		var c = TileManager.instance.get_neighbor_cell(pos, d)
		if TileManager.instance.has_air(c) and TileManager.instance.get_block(c) == null:
			TileManager.instance.instantiate_block(c, "WaterFlow")


func get_neighborhoods_with_type_at(c: Vector2i, t: String):
	# Get all the neighborhoods of type t of the current block
	var coords = []
	for d in directions:	
		coords.append(TileManager.instance.get_neighbor_cell(c, d))
	
	var neighborhoods = []

	for n in TileManager.instance.get_children():
		if n is BasicBlock:
			if n.type() == t and n.map_position() in coords:
				neighborhoods.append(n)	

	return neighborhoods

func update_distance():
	var neighborhoods = get_neighborhoods_with_type_at(map_position(), "WaterFlow")
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
