extends CollisionBlock

class_name Flag

@export var detecting: Array= []
@export var next_level: int

var flag = false

func _tick():
	for d in detecting:
		if neighborhoods_has_type(d):
			flag = true
			break
	
	if flag and WindowControl.instance.current_level < next_level:
		WindowControl.instance.change_to_level(next_level)
	
	if flag:
		$CPUParticles2D.emitting = true
		await get_tree().create_timer(0.5).timeout
		$CPUParticles2D.emitting = false
