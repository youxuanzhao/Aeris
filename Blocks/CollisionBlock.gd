extends BasicBlock

class_name CollisionBlock

# CollisionBlock
# Inherits from BasicBlock, with a collision box.

func _tick():
	super._tick()

func type():
	return "CollisionBlock"
