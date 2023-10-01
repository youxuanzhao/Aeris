extends Button

func _pressed():
	var anim = $"../../AnimationPlayer" as AnimationPlayer
	var root = $"../.."
	anim.play("fade_in")
	await anim.animation_finished
	var main = load("res://Scenes/main.tscn").instantiate()
	root.add_child(main)
	anim.play_backwards("fade_in")
