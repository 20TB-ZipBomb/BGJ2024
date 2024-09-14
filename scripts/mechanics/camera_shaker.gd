extends Node

class_name CameraShaker

@export var random_strength: float = 2.0
@export var shake_fade: float = 10.0
@export var camera: Camera3D = null

var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0
var base_camera_position: Vector3 = Vector3()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	base_camera_position = camera.position
	pass # Replace with function body.

func apply_shake() -> void:
	shake_strength = random_strength

func randomOffset() -> Vector3:
	return Vector3(
		rng.randf_range(-shake_strength,shake_strength),
		rng.randf_range(-shake_strength,shake_strength),
		0
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade*delta)
		if camera:
			camera.position = base_camera_position + randomOffset()
	else:
		camera.position = base_camera_position
	pass
