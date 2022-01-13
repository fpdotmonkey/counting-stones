extends Node


signal high_score(score)


var _high_scores = {}
var _current_level = null


func _on_main_new_level(node_path: NodePath):
    _current_level = node_path
    if not node_path in _high_scores:
        _high_scores[node_path] = 0
    emit_signal("high_score", _high_scores.get(_current_level, 0))


func _on_Game_Controller_next_stone_is(value: int):
    if _current_level == null:
        return

    var current_score = value - 1
    if current_score > _high_scores.get(_current_level, -1):
        _high_scores[_current_level] = current_score
        emit_signal("high_score", current_score)
