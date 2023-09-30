extends CharacterBody2D

var motion = Vector2(0,0)

func _ready():
	pass
	
func _input(event):
	motion = Vector2.ZERO
	
	if event.is_action_pressed("right"):
		motion.x = 8
	elif event.is_action_pressed("left"):
		motion.x = -8
	elif event.is_action_pressed("up"):
		motion.y = -8
	elif event.is_action_pressed("down"):
		motion.y = 8
	
	move_and_collide(motion)
