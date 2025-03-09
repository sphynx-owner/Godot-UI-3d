@tool
extends Node

var _unique_id_counter := 0

## shape: {[id: int]: [ui_3d: UI3D]}
var _ui_3d_by_id: Dictionary

func subscribe_ui_3d(ui_3d: UI3D) -> void:
	ui_3d.unique_id = _unique_id_counter
	_unique_id_counter += 1
	
	_ui_3d_by_id[ui_3d.unique_id] = ui_3d


func unsubscribe_ui_3d(ui_3d: UI3D) -> void:
	_ui_3d_by_id.erase(ui_3d.unique_id)


func get_ui_3d_for_id(id: int) -> UI3D:
	return _ui_3d_by_id[id]
