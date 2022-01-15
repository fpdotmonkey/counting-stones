extends Node


onready var _scores_label = get_node("VBoxTop/Scores")
var _high_score = 0
var _undo_count = 0
var _misplaced_stone_count = 0


func update_label():
    var format = "High score: %d\nUndos: %d\nMisplaced tiles: %d"
    _scores_label.set_text(
        format % [_high_score, _undo_count, _misplaced_stone_count]
    )


func _ready():
    update_label()


func _on_Game_State_game_state(
    high_score: int,
    undo_count: int,
    misplaced_stone_count: int,
    next_stone_value: int
):
    _high_score = high_score
    _undo_count = undo_count
    _misplaced_stone_count = misplaced_stone_count
    update_label()
