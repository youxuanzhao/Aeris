extends Sprite2D

var holdingAir : bool = false

func _ready():
	$AnimationPlayer.play("idle")
	$whitecover.visible = holdingAir

func on_space():
	var Coordinate = TileManager.instance.local_to_map(global_position)
	if TileManager.instance.has_moveable_air(Coordinate) != holdingAir:
		$"..".save_state()
		TileManager.instance.set_air(Coordinate, holdingAir)
		holdingAir = !holdingAir
	else:
		$AnimationPlayer.play("warning")
		$AnimationPlayer.queue("idle")
		return
		
func _process(_delta):
	$whitecover.visible = holdingAir
