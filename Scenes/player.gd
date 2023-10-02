extends CharacterBody2D

var sfx: SoundEffects

func _ready():
	sfx = $SoundEffects as SoundEffects

var states = []

func save_state():
	states.append({
		"pos": position,
		"frame": $Sprite2D.frame,
		"selected": $Selected.position,
		"holdingAir": $Selected.holdingAir
	})

	if states.size() > 10:
		states.remove_at(0)

func undo():
	if states.size() == 0:
		return
	
	var last = states.pop_back()
	position = last["pos"]
	$Sprite2D.frame = last["frame"]
	$Selected.position = last["selected"]
	$Selected.holdingAir = last["holdingAir"]
	
func _input(event):
	if MyPopup.instance.is_open():
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
		save_state()
		$Selected.position = Vector2(8,0)
		$Sprite2D.frame = 1
	elif event.is_action_pressed("arrow_left"):
		save_state()
		$Selected.position = Vector2(-8,0)
		$Sprite2D.frame = 0
	elif event.is_action_pressed("arrow_up"):
		save_state()
		$Selected.position = Vector2(0,-8)
		$Sprite2D.frame = 2
	elif event.is_action_pressed("arrow_down"):
		save_state()
		$Selected.position = Vector2(0,8)
		$Sprite2D.frame = 3
	
	
	var coll = move_and_collide(velocity)
	if coll:
		# Collision happens
		sfx.play_audio("collide")
	elif velocity.length() > 0:
		# Normal movement
		sfx.play_audio("walk")
		TileManager.instance.tick_all()
	
	position = TileManager.instance.map_to_local(TileManager.instance.local_to_map(position))

	# Check if position is outof homearea
	if WindowControl.instance.current_level == 0:
		if position.x < 88 or position.x > 176 or position.y < 88 or position.y > 176:
			WindowControl.instance.change_to_level(1)

