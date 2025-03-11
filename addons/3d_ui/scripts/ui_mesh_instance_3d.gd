@tool
class_name UIMeshInstance3D
extends MeshInstance3D

const ui_mesh_instance_3d_default_material: ShaderMaterial = preload("res://addons/3d_ui/resources/ui_mesh_instance_3d_material.tres")
const ui_mesh_instance_3d_shader: Shader = preload("res://addons/3d_ui/resources/3d_ui.gdshader")

@export var ui_3d: UI3D:
	set(value):
		if ui_3d and ui_3d.unique_id_changed.is_connected(_update_ui_3d_setup):
			ui_3d.unique_id_changed.disconnect(_update_ui_3d_setup)
		
		if ui_3d and ui_3d.ready.is_connected(_update_ui_3d_setup):
			ui_3d.ready.disconnect(_update_ui_3d_setup)
		
		ui_3d = value
		
		if ui_3d and not ui_3d.unique_id_changed.is_connected(_update_ui_3d_setup):
			ui_3d.unique_id_changed.connect(_update_ui_3d_setup)
		
		if ui_3d and ui_3d.is_node_ready():
			_update_ui_3d_setup()
		else:
			ui_3d.ready.connect(_update_ui_3d_setup, CONNECT_ONE_SHOT)
		
		update_configuration_warnings()

@export var target_surface_material_override_id := 0:
	set(value):
		target_surface_material_override_id = value
		
		update_configuration_warnings()
		notify_property_list_changed()
		
		_update_ui_3d_setup()

@export var ui_offset := Vector2(0, 0):
	set(value):
		ui_offset = value
		
		_update_ui_3d_setup()

@export var ui_scale := Vector2(1, 1):
	set(value):
		ui_scale = value
		
		_update_ui_3d_setup()

@export var ui_rotation := 0.0:
	set(value):
		ui_rotation = value
		
		_update_ui_3d_setup()

@export var out_of_bounds_color: Color = Color.BLACK:
	set(value):
		out_of_bounds_color = value
		
		_update_ui_3d_setup()

var _material_setter_gate := false


func _ready():
	_update_ui_3d_setup()


func _get_configuration_warnings() -> PackedStringArray:
	var ret: PackedStringArray
	if not _get_target_material_property() in self:
		ret.append("target surface override material id does not exist")
	if not ui_3d:
		ret.append("no UI3D configured")
	
	var has_collider_child := false
	
	for child in get_children():
		if child is CollisionObject3D:
			has_collider_child = true
			break
	
	if !has_collider_child:
		ret.append("missing child collider for the cursor to detect")
	
	return ret


func _set(property: StringName, value: Variant) -> bool:
	if property == "mesh":
		update_configuration_warnings()
		_update_ui_3d_setup.call_deferred()
	if property == _get_target_material_property():
		if _material_setter_gate:
			_material_setter_gate = false
			return false
		return true
	return false


func _update_ui_3d_setup():
	if ui_3d and _get_target_material_property() in self:
		if !get(_get_target_material_property()) or \
		get(_get_target_material_property()) is not ShaderMaterial or \
		get(_get_target_material_property()).shader != ui_mesh_instance_3d_shader:
			_material_setter_gate = true
			self.set(_get_target_material_property(), ui_mesh_instance_3d_default_material.duplicate())
		get(_get_target_material_property()).set_shader_parameter("albedo_texture", ui_3d.get_texture())
		get(_get_target_material_property()).set_shader_parameter("id", ui_3d.unique_id)
		get(_get_target_material_property()).set_shader_parameter("uv_offset", ui_offset)
		get(_get_target_material_property()).set_shader_parameter("uv_scale", ui_scale)
		get(_get_target_material_property()).set_shader_parameter("uv_rotation", ui_rotation)
		get(_get_target_material_property()).set_shader_parameter("out_of_bounds_color", out_of_bounds_color)


func _get_target_material_property() -> String:
	return "surface_material_override/" + str(target_surface_material_override_id)
