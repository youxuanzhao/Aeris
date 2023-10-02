extends CollisionBlock

func _ready():
	lifespan = -1

func type():
	return "FireSpark"

func _tick():
	super._tick()
	if has_air():
		lifespan = 0
	
func _dead():
	change_to("Fire")
