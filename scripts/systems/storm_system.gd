extends Node

## The scene spawned for animals.
## @TODO: Implement for multiple animals?
@export var animal_scene: PackedScene = null
## Number of animals spawned per tick of the StormTimer.
@export var animals_per_wave: int = 5

@onready var animal_spawn_location_on_path = $SpawnPath/SpawnLocation


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass

## Signal fired whenever the StormTimer ticks.
func _on_storm_timer_timeout() -> void:
	# Spin for a random point on a path
	animal_spawn_location_on_path.progress_ratio = randf()

	# Spawn animals along the path
	for i in animals_per_wave:
		var animal: Animal = animal_scene.instantiate()
		# Line them up in a line for the time being to prevent the colliders from hitting each other
		animal.position = animal_spawn_location_on_path.position + Vector3(i, 0, 0)
		add_child(animal)
