extends CollisionBlock

class_name Flag

@export var detecting: Array= []
@export var next_level: int
@export var activate_frame: int
@export var deactivate_frame: int
@export var my_type: String = "Flag"

var flag = false

func _ready():
	$Sprite2D.frame = deactivate_frame
	$"CPUParticles2D".emitting = false
	super._ready()

func type():
	return my_type

func game_over():
	pass

func _after_tick():
	flag = false
	for d in detecting:
		if d == "Air":
			if has_air() or neighborhoods_has_type("WaterVapor"):
				flag = true
				break
		if neighborhoods_has_type(d):
			flag = true
			break

	
	if flag and WindowControl.instance.current_level < next_level:
		$"CPUParticles2D".emitting = true
		if next_level > 4:
			# Game Over
			GameOver.instance.win()
		else:
			WindowControl.instance.change_to_level(next_level)

	
	if flag:
		$Sprite2D.frame = activate_frame
	else:
		$Sprite2D.frame = deactivate_frame
