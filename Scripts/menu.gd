extends Control

class_name MyPopup

static var instance

func _ready():
	instance = self

func is_open():
	return ($"CanvasLayer/Panel" as Panel).mouse_filter == Control.MOUSE_FILTER_STOP