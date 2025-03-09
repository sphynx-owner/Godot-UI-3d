class_name Cursor3D
extends SubViewport

var viewport_texture: Texture2D

var past_position: Vector2

func _ready() -> void:
	viewport_texture = get_texture()


func update_mouse_position(event: InputEventMouseMotion) -> void:
	var center_pixel: Color = viewport_texture.get_image().get_pixelv(Vector2i(1, 1))
	var current_uv: Vector2 = Vector2(center_pixel.r, center_pixel.g)
	
	event.position = current_uv * Vector2($"../SubViewport2".size)
	event.relative = event.position - past_position
	event.screen_relative = event.position - past_position
	past_position = event.position
