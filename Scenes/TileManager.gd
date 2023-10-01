extends TileMap

class_name TileManager

static var instance: TileManager
const symbol_layer = 1
const mask_layer = 2
const BlackMask = Vector3i(2,0,0)

var m = {
}

func _ready():
	instance = self
	
func has_air(c: Vector2i) -> bool:
	return get_cell_tile_data(mask_layer, c) == null

func set_air(c: Vector2i, air: bool):
	if air:
		set_cell(mask_layer, c)
	else:
		set_cell(mask_layer, c,BlackMask.x,Vector2i(BlackMask.y,BlackMask.z))

	
func get_block(c: Vector2i) -> BasicBlock:
	for n in get_children():
		if n is BasicBlock:
			if n.map_position() == c:
				return n
	
	return null
	

func instantiate_block(c: Vector2i, type: String):
	if type not in m:
		m[type] = load("res://Blocks/" + type + ".tscn")
	var block = m[type].instantiate() as BasicBlock
	add_child(block)
	block.set_map_position(c)
	return block


const movement_actions = [
	"move_up",
	"move_down",
	"move_left",
	"move_right"
]


func tick_all():
	# For each tile in symbol layer: trigger _tick	
	for n in get_children():
		if n is BasicBlock:
			n._tick()

	# TODO: Serialize all tiles

func _input(event):
	if MyPopup.instance.is_open():
		return

	# Check if is move event
	for n in movement_actions:
		if event.is_action_released(n):
			print("tick")
			tick_all()
			break
	
