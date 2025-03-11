@tool
class_name Cursor3D
extends Node3D

var _generated_subviewport: SubViewport

var _generated_camera: Camera3D

var viewport_texture: Texture2D

func _ready() -> void:
	_generated_subviewport = SubViewport.new()
	_generated_subviewport.size = Vector2i(3, 3)
	_generated_subviewport.debug_draw = SubViewport.DEBUG_DRAW_UNSHADED
	_generated_subviewport.use_hdr_2d = true
	_generated_subviewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	add_child(_generated_subviewport)
	
	_generated_camera = Camera3D.new()
	_generated_camera.cull_mask -= 1 << 19
	_generated_subviewport.add_child(_generated_camera)
	
	viewport_texture = _generated_subviewport.get_texture()

func _input(event: InputEvent) -> void:
	if event is InputEventMouse:
		var center_pixel: Color = viewport_texture.get_image().get_pixelv(Vector2i(1, 1))
		var current_uv: Vector2 = Vector2(center_pixel.r, center_pixel.g)
		var current_id: int = floor(center_pixel.b)
		
		# ID of 0 is used to signify that there is no ui available
		if current_id == 0:
			return
		
		var target_ui_3d: UI3D = UI3DManager.get_ui_3d_for_id(current_id)
		
		if !target_ui_3d:
			return
		
		var event_duplicate: InputEventMouse = event.duplicate(true)
		
		event_duplicate.position = current_uv * Vector2(target_ui_3d.size)
		target_ui_3d.push_input(event_duplicate)


func _process(delta: float) -> void:
	_generated_camera.global_transform = global_transform
