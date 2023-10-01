extends Node2D

class_name BasicBlock

# Basic Block
# The father of all blocks. With properties and methods that are common to all blocks.

var lifespan = -1 # Live for x ticks, -1 for infinite

func _dead():
	# Called when the block is dead
	queue_free()

func _tick():
	if lifespan >= 0:
		lifespan -= 1
		if lifespan == 0:
			_dead()

func type():
	return "basic"

func map_position() -> Vector2i:
	return TileManager.instance.local_to_map(global_position)

func has_air() -> bool:
	# If the block has air on top of it
	return TileManager.instance.has_air(map_position())

func change_to(new: PackedScene):
	# Change current block to another block
	var pos = global_position
	var parent = get_parent()
	queue_free()
	var new_block = new.instance()
	parent.add_child(new_block)
	new_block.global_position = pos

const directions = [
	TileSet.CELL_NEIGHBOR_TOP_SIDE,
	TileSet.CELL_NEIGHBOR_BOTTOM_SIDE,
	TileSet.CELL_NEIGHBOR_LEFT_SIDE,
	TileSet.CELL_NEIGHBOR_RIGHT_SIDE,
]

func get_neighborhoods():
	# Get all the neighborhoods of the current block
	var coords = []
	for d in directions:	
		coords.append(TileManager.instance.get_neighbor_cell(map_position(), d))
	
	var neighborhoods = []

	for n in TileManager.instance.get_children():
		if n is BasicBlock:
			if n.map_position() in coords:
				neighborhoods.append(n)
			
	return neighborhoods


func get_neighborhoods_with_type(t: String):
	# Get all the neighborhoods of type t of the current block
	var coords = []
	for d in directions:	
		coords.append(TileManager.instance.get_neighbor_cell(map_position(), d))
	
	var neighborhoods = []

	for n in TileManager.instance.get_children():
		if n is BasicBlock:
			if n.type() == t and n.map_position() in coords:
				neighborhoods.append(n)	

	return neighborhoods
