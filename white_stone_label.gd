extends Label

func init(value: int, location: Vector2):
    set_label(value)
    set_position(location)


func set_label(value: int):
    set_text(str(value))
