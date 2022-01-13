extends Node


signal new_level(node_path)


export(Array, PackedScene) var level_list
var _level_list_index = -1
var _current_level: Node


func initialize_level(level_scene: PackedScene) -> NodePath:
    var scene = level_scene.instance()
    add_child(scene)
    _current_level = scene
    return scene.get_path()


func destroy_current_level():
    _current_level.free()
    _current_level = null


func _ready():
    go_to_next_level()


func go_to_next_level():
    if _current_level != null:
        destroy_current_level()
    _level_list_index = (_level_list_index + 1) % level_list.size()
    emit_signal("new_level", initialize_level(level_list[_level_list_index]))


func go_to_previous_level():
    if _current_level != null:
        destroy_current_level()
    _level_list_index = (_level_list_index - 1) % level_list.size()
    emit_signal("new_level", initialize_level(level_list[_level_list_index]))


func reset_level():
    if _current_level == null:
        return
    destroy_current_level()
    emit_signal("new_level", initialize_level(level_list[_level_list_index]))


func key_down(event: InputEvent, scancode: int) -> bool:
    return (
        event.scancode == scancode
        and not event.is_echo()
        and event.is_pressed()
    )



func _input(event):
    if level_list.size() < 2 or _current_level == null:
        return

    if event is InputEventKey:
        if key_down(event, KEY_N):
            go_to_next_level()
        elif key_down(event, KEY_P):
            go_to_previous_level()
        elif key_down(event, KEY_R):
            reset_level()
