@tool
class_name Cursor3D
extends Node3D

var _generated_subviewport: SubViewport

var _generated_camera: Camera3D

var viewport_texture: Texture2D

var past_position: Vector2

func _ready() -> void:
	_generated_subviewport = SubViewport.new()
	_generated_subviewport.size = Vector2i(3, 3)
	_generated_subviewport.debug_draw = Viewport.DEBUG_DRAW_UNSHADED
	_generated_subviewport.use_hdr_2dq = true
	_generated_subviewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	add_child(_generated_subviewport)
	
	_generated_camera = Camera3D.new()
	_generated_camera.cull_mask -= 1 << 19
	_generated_subviewport.add_child(_generated_camera)
	
	viewport_texture = _generated_subviewport.get_texture()


func update_mouse_position(event: InputEventMouseMotion) -> void:
	var center_pixel: Color = viewport_texture.get_image().get_pixelv(Vector2i(1, 1))
	var current_uv: Vector2 = Vector2(center_pixel.r, center_pixel.g)
	
	event.position = current_uv * Vector2($"../SubViewport2".size)
	event.relative = event.position - past_position
	event.screen_relative = event.position - past_position
	past_position = event.position
