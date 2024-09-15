extends AnimatedSprite3D


func _process(_delta):
	var animal: CharacterBody3D = owner
	if animal.velocity.length() < 0.05:
		play("idle")
	else:
		play("walk")
	if animal.velocity.x < -0.05:
		rotation.y = PI
	elif animal.velocity.x > 0.05:
		rotation.y = 0
