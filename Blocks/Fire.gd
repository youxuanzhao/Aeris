extends CollisionBlock

func _ready():
	super._ready()
	lifespan = -1

func type():
	return "Fire"

func _tick():
	super._tick()
	if !has_air():
		change_to("FireSpark")
		return
	if neighborhoods_has_type("WaterFlow") or neighborhoods_has_type("WaterSource"):
		change_to("WaterVapor")
