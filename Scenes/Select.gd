extends Sprite2D

func _ready():
	$whitecover.visible = false
func _input(event):
	if event.is_action_pressed("space"):
		$whitecover.visible = !($whitecover.visible)
