extends Node


onready var _high_score_value = get_node(
    "VBoxTop/HBoxContainer/Scores/Score list/High score value"
)
onready var _undos_value = get_node(
    "VBoxTop/HBoxContainer/Scores/Score list/Undos value"
)
onready var _misplaced_stone_value = get_node(
    "VBoxTop/HBoxContainer/Scores/Score list/Misplaced stones value"
)
var _high_score = 0
var _undo_count = 0
var _misplaced_stone_count = 0


func update_label():
    _high_score_value.set_text(str(_high_score))
    _undos_value.set_text(str(_undo_count))
    _misplaced_stone_value.set_text(str(_misplaced_stone_count))


func _ready():
    update_label()


func _on_Game_State_game_state(
    high_score: int,
    undo_count: int,
    misplaced_stone_count: int,
    _next_stone_value: int
):
    _high_score = high_score
    _undo_count = undo_count
    _misplaced_stone_count = misplaced_stone_count
    update_label()
