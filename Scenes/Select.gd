extends Sprite2D

@export var map : TileMap

var temp

var stamp_coords

func _ready():
	$AnimationPlayer.play("idle")
	$whitecover.visible = false
	
	
func _input(event):
	if event.is_action_pressed("space"):
		temp = map.get_cell_tile_data(2,map.local_to_map(global_position))
		print(global_position)
		if temp != null:
			map.set_cell(2,map.local_to_map(global_position),-1,Vector2i(-1,-1),-1)
			map.set_cell(2,stamp_coords,2,Vector2i(0,0),0)
			$whitecover.visible = false
		else:
			stamp_coords = map.local_to_map(global_position)
			$whitecover.visible = true
	
