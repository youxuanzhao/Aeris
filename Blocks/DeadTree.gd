extends BasicBlock

func _tick():
    if len(get_neighborhoods_with_type("Fire")) < 0 and has_air():
        # Resurrect
        if lifespan == -1:
            lifespan = 3
    else:
        lifespan = -1

func type():
    return "DeadTree"


func _dead():
    change_to("Tree")