extends AudioStreamPlayer

func _ready():
    finished.connect(on_finished)

func on_finished():
    play(0)