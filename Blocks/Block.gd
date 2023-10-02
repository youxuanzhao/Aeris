extends Node2D

class_name BasicBlock

# Basic Block
# The father of all blocks. With properties and methods that are common to all blocks.

var lifespan = -1 # Live for x ticks, -1 for infinite

var Burnable = false
var Burnt = false

func _ready():
	TileManager.instance.register_block(map_position(),self)
	if $AnimationPlayer != null:
		$AnimationPlayer.play("appear")

func _dead():
	TileManager.instance.deregister_block(map_position(),self)
	if $AnimationPlayer != null:
		$AnimationPlayer.play("disappear")

func _before_tick():
	# Called before every tick
	pass

func _tick():
	if lifespan >= 0:
		if lifespan == 0:
			_dead()
		lifespan -= 1

func type():
	return "Block"

func map_position() -> Vector2i:
	return TileManager.instance.local_to_map(global_position)

func set_map_position(pos: Vector2i):
	global_position = TileManager.instance.map_to_local(pos)

func has_air() -> bool:
	# If the block has air on top of it
	return TileManager.instance.has_air(map_position())

var is_changing_to = null
func change_to(new: String):
	# Change current block to another block
	# This will happen at the end of current tick
	is_changing_to = new

const directions = [
	TileSet.CELL_NEIGHBOR_TOP_SIDE,
	TileSet.CELL_NEIGHBOR_BOTTOM_SIDE,
	TileSet.CELL_NEIGHBOR_LEFT_SIDE,
	TileSet.CELL_NEIGHBOR_RIGHT_SIDE,
]

func get_neighborhoods_coords(coord : Vector2i = map_position()) -> Array:
	var coords = []
	for d in directions:	
		coords.append(TileManager.instance.get_neighbor_cell(coord, d))
	return coords
	
func coord_has(t:String,coord : Vector2i) -> bool:
	if !TileManager.instance.blockDictionary.has(coord):
		return false
	for block in TileManager.instance.blockDictionary[coord]:
		if block.type() == t:
				return true
	return false

func get_neighborhoods(coord : Vector2i = map_position()):
	# Get all the neighborhoods of the current block
	var neighborhoods = []
	
	for Coord in get_neighborhoods_coords(coord):
		if !TileManager.instance.blockDictionary.has(Coord):
			continue
		neighborhoods.append_array(TileManager.instance.blockDictionary[Coord])
	return neighborhoods

func get_neighborhoods_with_type(t: String,coord : Vector2i = map_position()) -> Array:
	# Get all the neighborhoods of type t of the current block
	var neighborhoods = []
	
	for Coord in get_neighborhoods_coords(coord):
		if !TileManager.instance.blockDictionary.has(Coord):
			continue
		for block in TileManager.instance.blockDictionary[Coord]:
			if block.type() == t:
				neighborhoods.append(block)	
	return neighborhoods
	
func neighborhoods_has_type(t: String,coord : Vector2i = map_position()) -> bool:
	for Coord in get_neighborhoods_coords(coord):
		if coord_has(t,Coord):
			return true
	return false


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "disappear":
		queue_free()
