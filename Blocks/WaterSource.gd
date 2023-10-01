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


func _tick():
    WaterSource.expand(map_position())
