extends Control

class_name LevelPrompt

static var instance

func _ready():
	instance = self


func show_timeout(lv: int, prompt: String, timeout: int = 1):
	$"Popup/Panel/Title".text = "Level " + str(lv)
	$"Popup/Panel/Prompt".text = prompt
	$"Popup".popup()

	await get_tree().create_timer(timeout).timeout

	$"Popup".hide()

func _input(event):
	if event.is_action_pressed("test"):
		show_timeout(1, "Welcome to the game!\n\nUse WASD or arrow keys to move.\n\nPress space to shoot.\n\nPress escape to pause the game.")
