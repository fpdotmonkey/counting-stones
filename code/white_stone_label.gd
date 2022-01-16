extends Control


onready var label = get_node("Label")


func init(value: int, location: Vector2):
    if label == null:
        label = get_node("Label")
    set_label(value)
    set_position(location)


func set_label(value: int):
    label.set_text(str(value))
