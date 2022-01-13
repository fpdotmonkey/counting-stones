extends Node


onready var _scores_label = get_node("VBoxTop/Scores")
var _high_score = 0
var _undo_count = 0
var _misplaced_stone_count = 0


func update_label(high_score: int, undo_count: int, misplaced_stone_count):
    var format = "High score: %d\nUndos: %d\nMisplaced tiles: %d"
    _scores_label.set_text(format % [high_score, undo_count, misplaced_stone_count])


func _ready():
    update_label(_high_score, _undo_count, _misplaced_stone_count)


func _on_Game_Controller_undo():
    _undo_count += 1
    update_label(_high_score, _undo_count, _misplaced_stone_count)


func _on_Game_Controller_misplaced_stone():
    _misplaced_stone_count += 1
    update_label(_high_score, _undo_count, _misplaced_stone_count)


func _on_main_new_level(path):
    _undo_count = 0
    _misplaced_stone_count = 0
    update_label(_high_score, _undo_count, _misplaced_stone_count)


func _on_High_Score_high_score(score):
    _high_score = score
    update_label(_high_score, _undo_count, _misplaced_stone_count)
