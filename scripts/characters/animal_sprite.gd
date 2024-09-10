extends Sprite3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var animal: CharacterBody3D = owner
	if animal.velocity.x < -0.05:
		rotation.y = PI
	elif animal.velocity.x > 0.05:
		rotation.y = 0
