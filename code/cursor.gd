extends Node2D


func _input(event):
    if event is InputEventMouseMotion:
        set_visible(true)
        position = event.position + Vector2(-50, -50)


func _on_Game_State_game_state(
    high_score, undo_count, misplaced_stone_count, next_stone_value
):
    get_node("White Stone Label").set_label(next_stone_value)
