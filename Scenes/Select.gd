extends Sprite2D

var holdingAir : bool = false

func _ready():
	$AnimationPlayer.play("idle")
	$whitecover.visible = holdingAir

func select():	
	var c = TileManager.instance.local_to_map(global_position)
	if TileManager.instance.has_moveable_air(c) != holdingAir:
		TileManager.instance.set_air(c, holdingAir)
		holdingAir = !holdingAir
	else:
		$AnimationPlayer.play("warning")
		$AnimationPlayer.queue("idle")
		return false

	return true
		
func _process(_delta):
	$whitecover.visible = holdingAir
