@tool
class_name UIMeshInstance3D
extends MeshInstance3D

const ui_mesh_instance_3d_default_material: ShaderMaterial = preload("res://addons/3d_ui/resources/ui_mesh_instance_3d_material.tres")

@export var ui_3d: UI3D:
	set(value):
		if ui_3d and ui_3d.unique_id_set.is_connected(_on_ui_3d_unique_id_set):
			ui_3d.unique_id_set.disconnect(_on_ui_3d_unique_id_set)
		
		ui_3d = value
		
		if ui_3d and not ui_3d.unique_id_set.is_connected(_on_ui_3d_unique_id_set):
			ui_3d.unique_id_set.connect(_on_ui_3d_unique_id_set)
		
		_on_ui_3d_unique_id_set(ui_3d.unique_id)

@export var target_surface_material_override_id := 0:
	set(value):
		target_surface_material_override_id = value
		
		update_configuration_warnings()
		notify_property_list_changed()
		
		if ("surface_material_override/" + str(target_surface_material_override_id)) in self:
			_material_setter_gate = true
			_current_ui_3d_material = ui_mesh_instance_3d_default_material.duplicate()
			set("surface_material_override/" + str(target_surface_material_override_id), _current_ui_3d_material)

var _material_setter_gate := false

var _current_ui_3d_material: ShaderMaterial


func _get_configuration_warnings() -> PackedStringArray:
	if not ("surface_material_override/" + str(target_surface_material_override_id)) in self:
		return ["target surface override material id does not exist"]
	return []


func _set(property: StringName, value: Variant) -> bool:
	if property == ("surface_material_override/" + str(target_surface_material_override_id)):
		if _material_setter_gate:
			_material_setter_gate = false
			return false
		return true
	return false


func _on_ui_3d_unique_id_set(unique_id: int) -> void:
	_current_ui_3d_material.set_shader_parameter("id", unique_id)
