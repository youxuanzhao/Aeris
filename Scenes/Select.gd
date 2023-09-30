extends Sprite2D

@export var map : TileMap

func _ready():
	$AnimationPlayer.play("idle")
	$whitecover.visible = false
	
	
func _input(event):
	if event.is_action_pressed("space"):
		$whitecover.visible = !($whitecover.visible)
	
