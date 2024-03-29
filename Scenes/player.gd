extends CharacterBody2D

class_name Player

static var instance
var sfx: SoundEffects

func _ready():
	instance = self
	sfx = $SoundEffects as SoundEffects

var states = []

func save_state():
	states.append({
		"pos": position,
		"frame": $Sprite2D.frame,
		"holdingAir": $Selected.holdingAir
	})

	if states.size() > 20:
		states.remove_at(0)

func undo():
	if states.size() == 0:
		return
	
	var last = states.pop_back()
	position = last["pos"]
	$Sprite2D.frame = last["frame"]
	$Selected.holdingAir = last["holdingAir"]
	
func _input(event):
	if MyPopup.instance.is_open():
		return
	
	if GameOver.instance.is_open():
		return


	if event.is_action_released("undo"):
		undo()
		return
	

	velocity = Vector2.ZERO
	
	if event.is_action_pressed("move_right"):
		velocity.x = 8
		
	elif event.is_action_pressed("move_left"):
		velocity.x = -8
		
	elif event.is_action_pressed("move_up"):
		velocity.y = -8
		
	elif event.is_action_pressed("move_down"):
		velocity.y = 8
		
	if velocity.length() > 0:
		save_state()
		
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
	
	
	if velocity.length() > 0:
		var prev_pos = position
		var coll = move_and_collide(velocity)

		var screen_pos = get_screen_transform().origin
		var screen_size = get_viewport().get_visible_rect().size
		var rect = Rect2( Vector2(0, 0) , screen_size)

		if coll:
			# Collision happens
			sfx.play_audio("collide")	
		elif not rect.has_point(screen_pos):
			# Out of bounds
			sfx.play_audio("collide")
			position = prev_pos
		else:
			# Normal movement
			sfx.play_audio("walk")
			TileManager.instance.save_state()
			TileManager.instance.tick_all()
	
	position = TileManager.instance.map_to_local(TileManager.instance.local_to_map(position))
	

	if event.is_action_pressed("space"):
		save_state()
		TileManager.instance.save_state()
		if not $Selected.select():
			sfx.play_audio("collide")
		elif $Selected.holdingAir:
			sfx.play_audio("up")
		else:
			sfx.play_audio("down")
		TileManager.instance.tick_all()
