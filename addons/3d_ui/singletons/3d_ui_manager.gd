@tool
extends Node

# I start at 1 so that I can signify the lack of ui when the blue channel is 0
var _unique_id_counter := 1

## shape: {[id: int]: [ui_3d: UI3D]}
var _ui_3d_by_id: Dictionary

var _fake_capture_enabled := false


func subscribe_ui_3d(ui_3d: UI3D) -> void:
	ui_3d.unique_id = _unique_id_counter
	_unique_id_counter += 1
	
	_ui_3d_by_id[ui_3d.unique_id] = ui_3d


func unsubscribe_ui_3d(ui_3d: UI3D) -> void:
	_ui_3d_by_id.erase(ui_3d.unique_id)


func get_ui_3d_for_id(id: int) -> UI3D:
	return _ui_3d_by_id.get(id)


func set_fake_capture_enabled(enabled: bool) -> void:
	_fake_capture_enabled = enabled


func _process(delta: float) -> void:
	if (get_window().get_mouse_position().x > get_window().size.x or \
	get_window().get_mouse_position().y > get_window().size.y or \
	get_window().get_mouse_position().x < 0 or \
	get_window().get_mouse_position().y < 0) and \
	get_window().has_focus() and \
	Input.mouse_mode == Input.MOUSE_MODE_HIDDEN and _fake_capture_enabled:
		DisplayServer.warp_mouse(get_window().get_mouse_position().posmodv(get_window().size))
