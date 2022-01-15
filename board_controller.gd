extends TileMap


const CHECKER_TILE = 0

const DARK_CHECKER = Vector2(0, 0)
const LIGHT_CHECKER = Vector2(1, 0)
const BROWN_STONE_DARK_CHECKER = Vector2(0, 1)
const BROWN_STONE_LIGHT_CHECKER = Vector2(1, 1)
const WHITE_STONE_DARK_CHECKER = Vector2(0, 2)
const WHITE_STONE_LIGHT_CHECKER = Vector2(1, 2)

var _white_stone_label = preload("res://White Stone Label.tscn")

var _placed_labels = {}


func query_stone(coordinate: Vector2) -> Vector2:
    return get_cell_autotile_coord(coordinate[0], coordinate[1])


func is_placeable_tile(coordinate: Vector2) -> bool:
    return get_cellv(coordinate) != -1 and query_stone(coordinate) in [DARK_CHECKER, LIGHT_CHECKER]


func place_stone(coordinate: Vector2, white_stone_value: int):
    var stone_on_tile = query_stone(coordinate)
    set_cell(
        coordinate[0], coordinate[1], CHECKER_TILE, false, false, false, stone_on_tile + WHITE_STONE_DARK_CHECKER
    )
    var label = _white_stone_label.instance()
    label.init(white_stone_value, map_to_world(coordinate))
    add_child(label)
    _placed_labels[coordinate] = label


func remove_stone(coordinate: Vector2):
    var stone_on_tile = query_stone(coordinate)
    if stone_on_tile.y == 0:
        return
    set_cell(
        coordinate[0], coordinate[1], CHECKER_TILE, false, false, false, Vector2(stone_on_tile.x, 0)
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
