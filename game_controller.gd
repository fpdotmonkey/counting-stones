extends Node


signal undo
signal misplaced_stone
signal next_stone_is(value)


var _current_level: Node
var _placed_tiles = {}
var _white_stone_value = 2
var _move_history = []


func is_valid_white_stone_spot(coordinate: Vector2, value: int) -> bool:
    if not _current_level.is_placeable_tile(coordinate):
        return false

    var local_value = 0
    for i in [-1, 0, 1]:
        for j in [-1, 0, 1]:
            var cell_coordinate = coordinate + Vector2(i, j)
            local_value += _placed_tiles.get(cell_coordinate, 0)

    if local_value != value:
        emit_signal("misplaced_stone")
        return false
    return true


func place_stone(coordinate: Vector2):
    if not is_valid_white_stone_spot(coordinate, _white_stone_value):
        return

    _current_level.place_stone(coordinate, _white_stone_value)

    _placed_tiles[coordinate] = _white_stone_value
    _white_stone_value += 1
    emit_signal("next_stone_is", _white_stone_value)
    _move_history.append(coordinate)


func undo():
    var undone_move = _move_history.pop_back()
    if undone_move == null:
        return

    _current_level.remove_stone(undone_move)
    _placed_tiles.erase(undone_move)
    _white_stone_value -= 1
    emit_signal("next_stone_is", _white_stone_value)
    emit_signal("undo")


func _on_main_new_level(node_path):
    _current_level = get_node(node_path)
    if not _current_level.has_method("initial_stones"):
        push_error("PackedScene %s is not a stone-counting level" % _current_level.name)
        return
    _placed_tiles = _current_level.initial_stones()
    _white_stone_value = 2
    _move_history = []

    emit_signal("next_stone_is", _white_stone_value)


func _input(event):
    if _current_level == null:
        return

    if event is InputEventMouseButton and event.pressed:
        if event.button_index == BUTTON_LEFT:
            place_stone(_current_level.world_to_map(event.position))
        if event.button_index == BUTTON_RIGHT:
            undo()
