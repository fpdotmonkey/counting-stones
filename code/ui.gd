extends Node


signal place_stone(viewport_coordinate)
signal undo
signal next_level
signal previous_level
signal reset_level


@onready var _game_click_target = get_node("Game Click Target")
@onready var _settings_panel = get_node("Settings")
@onready var _scores_panel = get_node("HUD/VBoxTop/Scores")
@onready var _high_score_value = get_node(
	"HUD/VBoxTop/Scores/Score list/High score value"
)

@onready var _settings_button = get_node("HUD/VBoxTop/Settings Button")
@onready var _undo_button = get_node("HUD/VBoxTop/Undo Button")
@onready var _next_level_button = get_node("HUD/VBoxTop/Next Level Button")
@onready var _previous_level_button = get_node(
	"HUD/VBoxTop/Previous Level Button"
)

@onready var _cursor = get_node("Cursor")
@onready var _cursor_value = get_node("Cursor/White Stone/White Stone Label")

var _high_score = 0
var _undo_count = 0
var _misplaced_stone_count = 0
var _play_visible = true


func update_scores():
	_high_score_value.set_text(str(_high_score))


func move_cursor_to(coordinate: Vector2):
	_cursor.set_position(coordinate + Vector2(-50, -50))


func set_cursor_label_to(value: int):
	_cursor_value.set_label(value)


func set_play_mode():
	show_cursor()
	_scores_panel.set_modulate(Color(1, 1, 1, 1))
	_undo_button.set_modulate(Color(1, 1, 1, 1))
	_undo_button.set_disabled(false)
	_next_level_button.set_modulate(Color(1, 1, 1, 1))
	_next_level_button.set_disabled(false)
	_previous_level_button.set_modulate(Color(1, 1, 1, 1))
	_previous_level_button.set_disabled(false)
	_settings_panel.set_visible(false)
	_game_click_target.set_disabled(false)
	_play_visible = true


func set_settings_mode():
	hide_cursor()
	_scores_panel.set_modulate(Color(1, 1, 1, 0))
	_undo_button.set_modulate(Color(1, 1, 1, 0))
	_undo_button.set_disabled(true)
	_next_level_button.set_modulate(Color(1, 1, 1, 0))
	_next_level_button.set_disabled(true)
	_previous_level_button.set_modulate(Color(1, 1, 1, 0))
	_previous_level_button.set_disabled(true)
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

	if not event.is_echo() and event.is_pressed():
		if InputMap.action_has_event("next_level", event):
			emit_signal("next_level")
		elif InputMap.action_has_event("previous_level", event):
			emit_signal("previous_level")
		elif InputMap.action_has_event("reset_level", event):
			emit_signal("reset_level")



func _on_Game_State_game_state(
	high_score: int,
	next_stone_value: int
):
	_high_score = high_score
	update_scores()
	set_cursor_label_to(next_stone_value)


func _on_Settings_Button_toggled(button_pressed: bool):
	if button_pressed:
		set_settings_mode()
	else:
		set_play_mode()


func _on_Undo_Button_pressed():
	emit_signal("undo")


func _on_Next_Level_Button_pressed():
	emit_signal("next_level")


func _on_Previous_Level_Button_pressed():
	emit_signal("previous_level")


func _on_Game_Click_Target_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			emit_signal("place_stone", event.position)
		if InputMap.action_has_event("undo", event):
			emit_signal("undo")


func _on_Game_Click_Target_mouse_entered():
	show_cursor()


func _on_Game_Click_Target_mouse_exited():
	hide_cursor()
