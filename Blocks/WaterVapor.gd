extends BasicBlock

func _ready():
	lifespan = 3
	Block = true

func type():
	return "WaterVapor"

func _dead():
	change_to("WaterFlow")
