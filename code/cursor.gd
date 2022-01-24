extends Node2D


func _input(event):
    if event is InputEventMouseMotion:
        set_visible(true)
        position = event.position + Vector2(-50, -50)


func _on_Game_State_game_state(
    _high_score, _undo_count, _misplaced_stone_count, next_stone_value
):
    get_node("White Stone Label").set_label(next_stone_value)
