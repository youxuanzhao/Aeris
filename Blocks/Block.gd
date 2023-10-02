extends Node2D

class_name BasicBlock

var Burnate = -1
var Sink = false
var Block = false
# Basic Block
# The father of all blocks. With properties and methods that are common to all blocks.

var lifespan = -1 # Live for x ticks, -1 for infinite
var no_animation = false # If true, no animation will be played

func _ready():
	if get_node_or_null("AnimationPlayer"):
		$AnimationPlayer.play("appear")
		if no_animation:
			$AnimationPlayer.seek(1)
	define_property()
	
func define_property():
	return

func _dead():
	if get_node_or_null("AnimationPlayer"):
		$AnimationPlayer.play_backwards("appear")
		await $AnimationPlayer.animation_finished
	queue_free()

func _before_tick():
	# Called before every tick
	pass

func _after_tick():
	# Called after every tick
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

const ExtraDirections = [
	TileSet.CELL_NEIGHBOR_TOP_RIGHT_CORNER,
	TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER,
	TileSet.CELL_NEIGHBOR_TOP_LEFT_CORNER,
	TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER,
]

func get_neighborhoods_coords(coord : Vector2i = map_position(),containsCorner : bool = false) -> Array:
	var coords = []
	for d in directions:	
		coords.append(TileManager.instance.get_neighbor_cell(coord, d))
	if !containsCorner:
		return coords
	for d in ExtraDirections:	
		coords.append(TileManager.instance.get_neighbor_cell(coord, d))
	return coords
	
func get_neighborhoods(coord : Vector2i = map_position(),containsCorner : bool = false):
	# Get all the neighborhoods of the current block
	var neighborhoods = []

	for c in get_neighborhoods_coords(coord,containsCorner):
		for block in TileManager.instance.get_blocks(c):
			if block:
				neighborhoods.append(block)

	return neighborhoods
	
func CoordinateBurnable(c:Vector2i) -> bool:
	for block in TileManager.instance.get_blocks(c):
		print_debug(block.Burnate)
		if block.Burnate > 0:
			print_debug("true")
			return true
	return false

func coordinate_has(c : Vector2i,t:String) -> bool:
	for block in TileManager.instance.get_blocks(c):
		if block.type() == t:
			return true
	return false

func get_neighborhoods_with_type(t: String, coord : Vector2i = map_position(),containsCorner : bool = false) -> Array:
	# Get all the neighborhoods of type t of the current block
	var neighborhoods = []
	
	for c in get_neighborhoods_coords(coord,containsCorner):
		for block in TileManager.instance.get_blocks(c):
			if block.type() == t:
				neighborhoods.append(block)
		
	return neighborhoods
	
func neighborhoods_has_type(t: String,coord : Vector2i = map_position(),containsCorner : bool = false) -> bool:
	for c in get_neighborhoods_coords(coord,containsCorner):
		for block in TileManager.instance.get_blocks(c):
			if block.type() == t:
				return true
	return false

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "disappear":
		queue_free()
