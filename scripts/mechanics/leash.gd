extends Node3D
class_name Leash

@export var end_node: Node3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at(end_node.global_position)
	scale.z = global_position.distance_to(end_node.global_position)
