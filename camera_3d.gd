extends Camera3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion && Input.mouse_mode == Input.MOUSE_MODE_HIDDEN:
		global_rotation_degrees -= Vector3(event.relative.y, event.relative.x, 0) / 3
		global_rotation_degrees.x = clamp(global_rotation_degrees.x, -89, 89)
	
	if Input.is_action_just_pressed("ESC"):
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE

func _process(delta: float) -> void:
	var movement : Vector2 = Input.get_vector("A", "D", "W", "S")
	var elevation : float = Input.get_vector("Q", "E", "Q", "E").x
	global_position += global_basis * Vector3(movement.x, elevation, movement.y) * delta * 5;
	if (get_window().get_mouse_position().x > get_window().size.x or get_window().get_mouse_position().y > get_window().size.y\
	or get_window().get_mouse_position().x < 0 or get_window().get_mouse_position().y < 0) and get_window().has_focus():
		DisplayServer.warp_mouse(get_window().get_mouse_position().posmodv(get_window().size))
