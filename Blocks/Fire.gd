extends CollisionBlock

func _ready():
	lifespan = 3

func type():
	return "fire"

func _dead():
	change_to("CollisionBlock")
