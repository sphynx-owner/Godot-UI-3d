@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_autoload_singleton("UI3DManager", "res://addons/3d_ui/singletons/3d_ui_manager.gd")


func _exit_tree() -> void:
	remove_autoload_singleton("UI3DManager")
