extends Area3D
class_name KillArea
## queue_free any Animal that collides with this area

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(func(body: Node3D):
		if body is Animal:
			body.queue_free()
	)
