extends TileMap

class_name TileManager

static var instance: TileManager
const symbol_layer = 1
const mask_layer = 2
const BlackMask = Vector3i(2,0,0)
const FakeAir = Vector3i(0, 0, 1)

# Cache: pos -> block
var cache = {}

func _ready():
	instance = self
	
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
	if not cache.has(c):
		return null

	return cache[c][0]
	
func get_blocks(c: Vector2i) -> Array:
	if not cache.has(c):
		return []
	return cache[c]
	
func coordinate_has(c : Vector2i,t:String) -> bool:
	for block in get_blocks(c):
		if block.type() == t:
			return true
	return false

func instantiate_block_now(c: Vector2i, type: String, no_animation = false, forced = false):
	if !forced:
		update_cache()
		if coordinate_has(c,type):
			return
	var s = load("res://Blocks/" + type + ".tscn")
	var block = s.instantiate()
	block.no_animation = no_animation
	block.set_map_position(c)
	add_child(block)
	return block

var new_block_queue = []
func instantiate_block(c: Vector2i, type: String):
	new_block_queue.append({
		"pos": c,
		"type": type
	})


const movement_actions = [
	"move_up",
	"move_down",
	"move_left",
	"move_right",
]

var states = []

func get_all_blocks() -> Array:
	return get_children().filter(func(n): return n is BasicBlock)

func update_cache():
	cache.clear()
	for n in get_all_blocks():
		var pos = n.map_position()
		if(cache.has(pos)):
			cache[pos].append(n)
		else:
			cache[pos] = [n]
	

func tick_all():
	print("tick")
	update_cache()
	
	for n in get_all_blocks():
		n._before_tick()

	# For each tile in symbol layer: trigger _tick	
	for n in get_all_blocks():
		n._tick()


	for n in get_all_blocks():
		if n.is_changing_to:
			var pos = n.map_position()
			instantiate_block_now(pos, n.is_changing_to)
			n._dead()
			n.queue_free()
	
	for n in new_block_queue:
		instantiate_block_now(n["pos"], n["type"])
	new_block_queue.clear()

	update_cache()
	# After tick
	for n in get_all_blocks():
		n._after_tick()
	
	# Check Tree / Fire grow on player
	var c = local_to_map(Player.instance.global_position)

	if get_block(c) and get_block(c).type() in ["Tree", "Fire"]:
		print("Game over")
		GameOver.instance.died()
	

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

	if states.size() > 20:
		states.remove_at(0)

func undo():
	if len(states) == 0:
		return

	var state = states.pop_back()
	
	# Remove all blocks
	for n in get_children():
		if n is BasicBlock:
			n.queue_free()
			
	cache.clear()
	
	# Clear mask
	for c in get_used_cells(mask_layer):
		set_cell(mask_layer, c)

	# Re-instantiate blocks
	for n in state["blocks"]:
		instantiate_block_now(n["pos"], n["type"], true, true)
		print_debug(n["type"])

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
	
