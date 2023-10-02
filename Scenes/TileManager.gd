extends TileMap

class_name TileManager

static var instance: TileManager
const symbol_layer = 1
const mask_layer = 2
const BlackMask = Vector3i(2,0,0)
const FakeAir = Vector3i(0, 0, 1)

var m = {
}

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
	for n in get_children():
		if n is BasicBlock:
			if n.map_position() == c:
				return n
	
	return null
	

func instantiate_block(c: Vector2i, type: String):
	var s = load("res://Blocks/" + type + ".tscn")
	var block = s.instantiate()
	add_child(block)
	block.set_map_position(c)
	return block


const movement_actions = [
	"move_up",
	"move_down",
	"move_left",
	"move_right",
]

var states = []

func tick_all():
	for n in get_children():
		if n is BasicBlock:
			n._before_tick()

	# For each tile in symbol layer: trigger _tick	
	for n in get_children():
		if n is BasicBlock:
			n._tick()

	for n in get_children():
		if n is BasicBlock:
			if n.is_changing_to:
				var pos = n.map_position()
				n.queue_free()
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
		instantiate_block(n["pos"], n["type"])

	# Re-instantiate mask
	for n in state["mask"]:
		set_cell(mask_layer, n["pos"], n["type"].x, Vector2i(n["type"].y, n["type"].z))	
	

func _input(event):
	if MyPopup.instance.is_open():
		return

	# Check if is move event
	for n in movement_actions:
		if event.is_action_pressed(n):
			print("tick")
			save_state()
			tick_all()

	if event.is_action_pressed("space"):
		save_state()
	
		%Selected.on_space()
		
		tick_all()
		return

	
	# Check if is undo event
	if event.is_action_pressed("undo"):
		undo()
		return
	
