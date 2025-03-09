@tool
extends Node

var _unique_id_counter := 0

## shape: {[id: int]: [ui_3d: UI3D]}
var _ui_3d_by_id: Dictionary

func subscribe_ui_3d(ui_3d: UI3D) -> int:
	_unique_id += 1
	return _unique_id
