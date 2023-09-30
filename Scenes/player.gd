extends CharacterBody2D

var sfx: SoundEffects

func _ready():
	sfx = $SoundEffects as SoundEffects
	
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
		$Sprite2D.frame = 1
	elif event.is_action_pressed("arrow_left"):
		$Selected.position = Vector2(-8,0)
		$Sprite2D.frame = 0
	elif event.is_action_pressed("arrow_up"):
		$Selected.position = Vector2(0,-8)
		$Sprite2D.frame = 2
	elif event.is_action_pressed("arrow_down"):
		$Selected.position = Vector2(0,8)
		$Sprite2D.frame = 3
	
	var coll = move_and_collide(velocity)
	if coll:
		# Collision happens
		sfx.play_audio("collide")
	elif velocity.length() > 0:
		# Normal movement
		sfx.play_audio("walk")
	
	position.x = round(position.x)
	position.y = round(position.y)
