extends Node


signal left_mouse_pressed(viewport_coordinate)
signal right_mouse_pressed(viewport_coordinate)


onready var _game_click_target = get_node("Game Click Target")
onready var _settings_panel = get_node("Settings")
onready var _scores_panel = get_node("HUD/VBoxTop/Scores")
onready var _high_score_value = get_node(
    "HUD/VBoxTop/Scores/Score list/High score value"
)
onready var _undos_value = get_node(
    "HUD/VBoxTop/Scores/Score list/Undos value"
)
onready var _misplaced_stone_value = get_node(
    "HUD/VBoxTop/Scores/Score list/Misplaced stones value"
)
onready var _settings_button = get_node(
    "HUD/VBoxTop/Settings Button"
)
onready var _cursor = get_node("Cursor")
onready var _cursor_value = get_node("Cursor/White Stone/White Stone Value")

var _high_score = 0
var _undo_count = 0
var _misplaced_stone_count = 0
var _play_visible = true


func update_scores():
    _high_score_value.set_text(str(_high_score))
    _undos_value.set_text(str(_undo_count))
    _misplaced_stone_value.set_text(str(_misplaced_stone_count))


func move_cursor_to(coordinate: Vector2):
    _cursor.set_position(coordinate + Vector2(-50, -50))


func set_cursor_value_to(value: int):
    _cursor_value.set_text(str(value))


func set_play_mode():
    show_cursor()
    _scores_panel.set_modulate(Color(1, 1, 1, 1))
    _settings_panel.set_visible(false)
    _game_click_target.set_disabled(false)
    _play_visible = true


func set_settings_mode():
    hide_cursor()
    _scores_panel.set_modulate(Color(1, 1, 1, 0))
    _settings_panel.set_visible(true)
    _game_click_target.set_disabled(true)
    _play_visible = false


func show_cursor():
    if _play_visible:
        _cursor.set_visible(true)


func hide_cursor():
    _cursor.set_visible(false)


func _ready():
    update_scores()
    set_play_mode()


func _input(event):
    if event is InputEventMouseMotion:
        move_cursor_to(event.position)


func _on_Game_State_game_state(
    high_score: int,
    undo_count: int,
    misplaced_stone_count: int,
    next_stone_value: int
):
    _high_score = high_score
    _undo_count = undo_count
    _misplaced_stone_count = misplaced_stone_count
    update_scores()
    set_cursor_value_to(next_stone_value)


func _on_Settings_Button_mouse_entered():
    hide_cursor()


func _on_Settings_Button_mouse_exited():
    show_cursor()


func _on_Settings_Button_toggled(button_pressed: bool):
    if button_pressed:
        set_settings_mode()
    else:
        set_play_mode()


func _on_Game_Click_Target_gui_input(event: InputEvent):
    if event is InputEventMouseButton and event.pressed:
        if event.button_index == BUTTON_LEFT:
            emit_signal("left_mouse_pressed", event.position)
        if event.button_index == BUTTON_RIGHT:
            emit_signal("right_mouse_pressed", event.position)
