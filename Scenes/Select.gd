extends Sprite2D

@export var map : TileMap

var temp
@onready var can_place : bool = false
var stamp_coords

func _ready():
	
	$AnimationPlayer.play("idle")
	$whitecover.visible = false
	
	
func _input(event):
	if event.is_action_pressed("space"):
		temp = map.get_cell_tile_data(2,map.local_to_map(global_position))
		print(global_position)
		if temp != null:
			if can_place:
				map.set_cell(2,map.local_to_map(global_position),-1,Vector2i(-1,-1),-1)
				can_place = false
				$whitecover.visible = false
			else:
				$AnimationPlayer.play("warning")
				$AnimationPlayer.queue("idle")
		else:
			can_place = true
			stamp_coords = map.local_to_map(global_position)
			map.set_cell(2,stamp_coords,2,Vector2i(0,0),0)
			$whitecover.visible = true
	
