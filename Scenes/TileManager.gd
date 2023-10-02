extends TileMap

class_name TileManager

static var instance: TileManager
const symbol_layer = 1
const mask_layer = 2
const BlackMask = Vector3i(2,0,0)
const FakeAir = Vector3i(0, 0, 1)

var blockDictionary : Dictionary

var m = {
}

func _ready():
	instance = self
	
func register_block(coordinate : Vector2i,block):
	if blockDictionary.has(coordinate):
		blockDictionary[coordinate].append(block)
		return
	blockDictionary[coordinate] = [block]
	
func deregister_block(coordinate : Vector2i,block):
	if blockDictionary.has(coordinate):
		blockDictionary[coordinate].erase(block)
	
func has_moveable_air(c: Vector2i) -> bool:
	return get_cell_tile_data(mask_layer, c) == null

func has_air(c: Vector2i) -> bool:
	var data = get_cell_tile_data(mask_layer, c)
	var atlas = get_cell_atlas_coords(mask_layer, c)
	var source = get_cell_source_id(mask_layer, c)
	return data == null or (atlas == Vector2i(FakeAir.y, FakeAir.z) and source == FakeAir.x)

func set_air(c: Vector2i, air: bool):
	if air:
		set_cell(mask_layer, c)
	else:
		set_cell(mask_layer, c,BlackMask.x,Vector2i(BlackMask.y,BlackMask.z))

func set_fake_air(c: Vector2i, air: bool):
	var data = get_cell_tile_data(mask_layer, c)
	if not data:
		return

	if air:
		set_cell(mask_layer, c, FakeAir.x, Vector2i(FakeAir.y, FakeAir.z))
	else:
		set_cell(mask_layer, c, BlackMask.x, Vector2i(BlackMask.y, BlackMask.z))

	
func get_block(c: Vector2i) -> BasicBlock:
	for n in get_children():
		if n is BasicBlock:
			if n.map_position() == c:
				return n
	
	return null
	

func instantiate_block(c: Vector2i, type: String):
	var s = load("res://Blocks/" + type + ".tscn")
	var block = s.instantiate()
	block.set_map_position(c)
	add_child(block)
	return block


const movement_actions = [
	"move_up",
	"move_down",
	"move_left",
	"move_right",
]

var states = []

func get_all_blocks() -> Array:
	var blocks = []
	for key in blockDictionary:
		blocks.append_array(blockDictionary[key])
	return blocks

func tick_all():
	print("tick")
	save_state()
	
	for n in get_all_blocks():
		n._before_tick()

	# For each tile in symbol layer: trigger _tick	
	for n in get_all_blocks():
		n._tick()

	for n in get_all_blocks():
		if n.is_changing_to:
			var pos = n.map_position()
			#n.queue_free()
			n._dead()
			instantiate_block(pos, n.is_changing_to)


func save_state():
	# Save state
	var blocks = []
	for n in get_children():
		if n is BasicBlock:
			blocks.append({
				"pos": n.map_position(),
				"type": n.type()
			})
	
	# Mask state
	var mask = []
	for c in get_used_cells(mask_layer):
		var atlas = get_cell_atlas_coords(mask_layer, c)
		var source = get_cell_source_id(mask_layer, c)
		mask.append({
			"pos": c,
			"type": Vector3i(source, atlas.x, atlas.y)
		})

	states.append({
		"blocks": blocks,
		"mask": mask	
	})

	if states.size() > 10:
		states.remove_at(0)

func undo():
	if len(states) == 0:
		return

	var state = states.pop_back()
	
	# Remove all blocks
	for n in get_children():
		if n is BasicBlock:
			n.queue_free()
	
	# Clear mask
	for c in get_used_cells(mask_layer):
		set_cell(mask_layer, c)

	# Re-instantiate blocks
	for n in state["blocks"]:
		var b = instantiate_block(n["pos"], n["type"])
		# TODO: Prevent animation	
		


	# Re-instantiate mask
	for n in state["mask"]:
		set_cell(mask_layer, n["pos"], n["type"].x, Vector2i(n["type"].y, n["type"].z))	
	

func _input(event):
	if MyPopup.instance.is_open():
		return
	
	# Check if is undo event
	if event.is_action_pressed("undo"):
		undo()
		return
	
