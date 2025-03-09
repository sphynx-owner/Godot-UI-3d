extends Camera3D

@export var camera_to_follow: Camera3D

func _process(_delta: float) -> void:
	global_transform = camera_to_follow.global_transform
