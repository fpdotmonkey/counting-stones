extends Node


signal new_level(node_path)
signal reset_level(node_path)


@export var level_list: Array[PackedScene]
var _level_list_index = -1
var _current_level: Node


func initialize_level(level_scene: PackedScene) -> NodePath:
	var scene = level_scene.instantiate()
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


func do_reset_level():
	if _current_level == null:
		return
	destroy_current_level()
	emit_signal("reset_level", initialize_level(level_list[_level_list_index]))


func _on_UI_next_level():
	go_to_next_level()


func _on_UI_previous_level():
	go_to_previous_level()


func _on_UI_reset_level():
	do_reset_level()
