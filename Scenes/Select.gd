extends Sprite2D

var holdingAir : bool = false

func _ready():
	$AnimationPlayer.play("idle")
	$whitecover.visible = holdingAir
	
func _input(event):
	if event.is_action_pressed("space"):
		var Coordinate = TileManager.instance.local_to_map(global_position)
		if TileManager.instance.has_air(Coordinate) != holdingAir:
			TileManager.instance.set_air(Coordinate,holdingAir)
			holdingAir = !holdingAir
		else:
			$AnimationPlayer.play("warning")
			$AnimationPlayer.queue("idle")
			return
		$whitecover.visible = holdingAir
	
