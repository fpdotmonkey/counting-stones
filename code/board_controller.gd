extends TileMap


const CHECKER_TILE = 0

const DARK_CHECKER = Vector2i(0, 0)
const LIGHT_CHECKER = Vector2i(1, 0)
const BROWN_STONE_DARK_CHECKER = Vector2i(0, 1)
const BROWN_STONE_LIGHT_CHECKER = Vector2i(1, 1)
const WHITE_STONE_DARK_CHECKER = Vector2i(0, 2)
const WHITE_STONE_LIGHT_CHECKER = Vector2i(1, 2)

var _white_stone_label = preload("res://levels/White Stone Label.tscn")

var _placed_labels = {}


func query_stone(coordinate: Vector2i) -> Vector2i:
	return get_cell_atlas_coords(0, coordinate)


func is_placeable_tile(coordinate: Vector2i) -> bool:
	return (
		get_cell_source_id(0, coordinate) != -1
		and query_stone(coordinate) in [DARK_CHECKER, LIGHT_CHECKER]
	)


func place_stone(coordinate: Vector2i, white_stone_value: int):
	var stone_on_tile = query_stone(coordinate)
	set_cell(
		0,
		coordinate,
		CHECKER_TILE,
		stone_on_tile + WHITE_STONE_DARK_CHECKER
	)
	var label = _white_stone_label.instantiate()
	label.init(white_stone_value, map_to_local(coordinate) - 50 * Vector2(1, 1))
	add_child(label)
	_placed_labels[coordinate] = label


func remove_stone(coordinate: Vector2i):
	var stone_on_tile = query_stone(coordinate)
	if stone_on_tile.y == 0:
		return
	set_cell(
		0,
		coordinate,
		CHECKER_TILE,
		Vector2i(stone_on_tile.x, 0)
	)
	_placed_labels.get(coordinate).queue_free()


func initial_stones() -> Dictionary:
	var cells = get_used_cells_by_id(CHECKER_TILE)
	var stones = {}
	for cell in cells:
		var tile_coordinate = query_stone(cell)
		if tile_coordinate.y == 2:
			push_error("white stone in the level design at %s" % cell)
		if tile_coordinate.y == 1:
			stones[cell] = 1
	return stones


func populate_stones(stones: Dictionary) -> void:
	for coordinate in stones:
		if stones[coordinate] == 1:
			continue
		place_stone(coordinate, stones[coordinate])
