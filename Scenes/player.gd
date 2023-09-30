extends CharacterBody2D


func _ready():
	var selection = $Selected
	
func _input(event):
	
	velocity = Vector2.ZERO
	
	if event.is_action_pressed("move_right"):
		velocity.x = 8
	elif event.is_action_pressed("move_left"):
		velocity.x = -8
	elif event.is_action_pressed("move_up"):
		velocity.y = -8
	elif event.is_action_pressed("move_down"):
		velocity.y = 8
		
	if event.is_action_pressed("arrow_right"):
		$Selected.position = Vector2(8,0)

	elif event.is_action_pressed("arrow_left"):
		$Selected.position = Vector2(-8,0)

	elif event.is_action_pressed("arrow_up"):
		$Selected.position = Vector2(0,-8)

	elif event.is_action_pressed("arrow_down"):
		$Selected.position = Vector2(0,8)

	
	move_and_collide(velocity)
	
	position.x = round(position.x)
	position.y = round(position.y)
