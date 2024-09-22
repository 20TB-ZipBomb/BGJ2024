extends AnimatedSprite3D

var facing_left: bool = true

func _physics_process(_delta: float) -> void:
	if not visible:
		return
	
	var animal: CharacterBody3D = owner
	if animal.velocity.length() < 0.05:
		play("idle")
	else:
		play("walk")
	if facing_left and animal.velocity.x > 0.05:
		rotation.y = PI
		facing_left = false
		reset_physics_interpolation()
	elif not facing_left and animal.velocity.x < -0.05:
		rotation.y = 0
		facing_left = true
		reset_physics_interpolation()
