extends BasicBlock

const max_distance = 2

func set_direction(d: String):
    if d == "left":
        $Sprite2D.region_rect.x = 0
    else:
        $Sprite2D.region_rect.x = 8

func _tick():
    if not has_air():
        super._dead()
    
    # Check distance to nearest WaterSource
    var min_distance = max_distance + 1
    for n in TileManager.instance.get_children():
        if n is WaterSource:
            var distance = (map_position() - n.map_position()).length()
            if distance < min_distance:
                min_distance = distance
        
    if min_distance <= max_distance:
        # Able to expand
        WaterSource.expand(map_position())



        
