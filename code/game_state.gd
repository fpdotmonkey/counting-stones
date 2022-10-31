extends Node


signal game_state_up(node_path)
signal game_state(
    high_score, undo_count, misplaced_stone_count, next_stone_value
)


class LevelState:
    var _level: NodePath

    var _high_score = 0
    var _undo_count = 0
    var _misplaced_stone_count = 0
    var _next_stone_value = 0 setget set_next_stone_value, get_next_stone_value

    var _placed_stones = {} setget set_stones, get_stones
    var _move_history = []

    func _init(level: NodePath):
        _level = level

    func is_for_level(level: NodePath) -> bool:
        return level == _level

    func undo():
        var undone_move = _move_history.pop_back()
        if undone_move == null:
            return null

        _undo_count += 1
        _placed_stones.erase(undone_move)
        return undone_move


    func reset(next_stone_value: int, initial_stones: Dictionary):
        _next_stone_value = next_stone_value
        _placed_stones = initial_stones
        _move_history = []

    func misplace_stone():
        _misplaced_stone_count += 1

    func place_stone(coordinate: Vector2):
        _placed_stones[coordinate] = _next_stone_value
        _move_history.append(coordinate)
        if _next_stone_value > _high_score:
            _high_score = _next_stone_value

    func set_next_stone_value(value: int):
        _next_stone_value = value

    func get_next_stone_value() -> int:
        return _next_stone_value

    func set_stones(stones: Dictionary):
        _placed_stones = stones

    func get_stones() -> Dictionary:
        return _placed_stones


var _current_level_state: LevelState
var _level_states = []


func announce_game_state() -> void:
	emit_signal(
		"game_state",
		_current_level_state._high_score,
		_current_level_state._next_stone_value
	)


func change_level(level: NodePath):
    var level_state = null
    for _level_state in _level_states:
        if _level_state.is_for_level(level):
            level_state = _level_state
            break
    if level_state == null:
        level_state = LevelState.new(level)
        _level_states.append(level_state)
    _current_level_state = level_state
    announce_game_state()


func undo():
    var undone_move = _current_level_state.undo()
    announce_game_state()
    return undone_move


func reset(next_stone_value: int, initial_stones: Dictionary):
    _current_level_state.reset(next_stone_value, initial_stones)
    announce_game_state()


func place_stone(coordinate: Vector2):
    _current_level_state.place_stone(coordinate)
    announce_game_state()


func misplace_stone():
    _current_level_state.misplace_stone()
    announce_game_state()


func set_stones(stones: Dictionary):
    _current_level_state.set_stones(stones)


func get_stones() -> Dictionary:
    return _current_level_state.get_stones()


func set_next_stone_value(value: int):
    _current_level_state.set_next_stone_value(value)
    announce_game_state()


func set_next_stone_diff_value(diff_value: int):
    set_next_stone_value(get_next_stone_value() + diff_value)


func get_next_stone_value() -> int:
    return _current_level_state.get_next_stone_value()


func _ready():
    emit_signal("game_state_up", get_path())
