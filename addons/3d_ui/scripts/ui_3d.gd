@tool
class_name UI3D
extends SubViewport

signal unique_id_set(id: int)

var unique_id := 0:
	set(value):
		unique_id = value
		unique_id_set.emit(unique_id)


func _enter_tree() -> void:
	UI3DManager.subscribe_ui_3d(self)


func _exit_tree() -> void:
	UI3DManager.unsubscribe_ui_3d(self)
