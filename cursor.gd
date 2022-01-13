extends Node2D


func _input(event):
    if event is InputEventMouseMotion:
        set_visible(true)
        position = event.position + Vector2(-50, -50)


func _on_Game_Controller_next_stone_is(value: int):
    get_node("White Stone Label").set_label(value)
