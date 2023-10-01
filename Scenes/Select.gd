extends Sprite2D

@export var map : TileMap
var storedAir : bool = false

func _ready():
	$AnimationPlayer.play("idle")
	$whitecover.visible = storedAir
	
func _input(event):
	if event.is_action_pressed("space"):
		var Coordinate = TileManager.main.local_to_map(global_position)
		if TileManager.main.HasAir(Coordinate) != storedAir:
			TileManager.main.SetAir(Coordinate,storedAir)
			storedAir = !storedAir
		else:
			$AnimationPlayer.play("warning")
			$AnimationPlayer.queue("idle")
			return
		$whitecover.visible = storedAir
	
