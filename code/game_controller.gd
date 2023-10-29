extends Node


var _game_state: Node
var _current_level: Node


func is_valid_white_stone_spot(coordinate: Vector2i, value: int) -> bool:
	if not _current_level.is_placeable_tile(coordinate):
		return false

	var local_value = 0
	for i in [-1, 0, 1]:
		for j in [-1, 0, 1]:
			var cell_coordinate = coordinate + Vector2i(i, j)
			local_value += _game_state.get_stones().get(cell_coordinate, 0)

	if local_value != value:
		_game_state.misplace_stone()
		return false
	return true


func place_stone(coordinate: Vector2i):
	if not is_valid_white_stone_spot(
		coordinate, _game_state.get_next_stone_value()
	):
		return

	_current_level.place_stone(coordinate, _game_state.get_next_stone_value())
	_game_state.place_stone(coordinate)
	_game_state.set_next_stone_diff_value(1)


func undo():
	var undone_move = _game_state.undo()
	if undone_move == null:
		return

	_current_level.remove_stone(undone_move)
	_game_state.set_next_stone_diff_value(-1)


func _on_main_new_level(node_path):
	_current_level = get_node(node_path)
	if not _current_level.has_method("initial_stones"):
		push_error(
			"PackedScene %s is not a stone-counting level" % _current_level.name
		)
		return

	_game_state.change_level(_current_level.get_path())

	var previously_placed_stones: Dictionary = _game_state.get_stones()
	if not previously_placed_stones.is_empty():
		_current_level.populate_stones(previously_placed_stones)
	else:
		_game_state.set_stones(_current_level.initial_stones())

	if _game_state.get_next_stone_value() < 2:
		_game_state.set_next_stone_value(2)


func _on_main_reset_level(node_path):
	_current_level = get_node(node_path)
	_game_state.reset(2, _current_level.initial_stones())


func _on_Game_State_game_state_up(node_path: NodePath):
	_game_state = get_node(node_path)


func _on_UI_place_stone(viewport_coordinate: Vector2):
	place_stone(_current_level.local_to_map(viewport_coordinate))


func _on_UI_undo():
	undo()
