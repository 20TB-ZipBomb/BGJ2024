extends Node3D
class_name Tornado

@export_category("Animal")
@export var animal_scene: PackedScene = null
@export_category("Tornado Metrics")
@export var tornado_speed: float = 0.01
@export var tornado_duration: float = 10.0
## Maximum number of storms to incur before the difficulty curve peaks.
@export var max_number_of_storms_before_max_difficulty: int = 10
## Difficulty curve for the number of animals being spawned in each wave.
##
## The x-axis for the curve represents the percentage of rounds completed based on `max_number_of_storms`
## and the y-axis represents the number of animals to spawn in.
@export var storm_difficulty_curve: Curve = null

@onready var movement_path: PathFollow3D = $TornadoMovePath/TornadoSpawnLocation

var curved_num_animals_to_spawn: int = 0


func _ready() -> void:
	# Initialize the tornado in a random position on its path
	movement_path.progress_ratio = randf()

	# Determine the number of cows to spawn using the current wave number,
	# the maximum number of cows per storm, and the difficulty curve
	# @TODO: Port this logic for the tornado spawning... I think?
	var sample_point: float = float(Globals.current_storm_wave_number) / float(max_number_of_storms_before_max_difficulty)
	curved_num_animals_to_spawn = floor(storm_difficulty_curve.sample(sample_point))


func _process(delta: float) -> void:
	movement_path.progress_ratio += tornado_speed * delta
	position = movement_path.position
	# After first update, turn the visibility on
	visible = true


## When the despawn timer is triggered, remove this tornado from the level
func _on_despawn_timer_timeout() -> void:
	queue_free()


## When the animal spawn timer is triggered, throw an animal out near the tornado
func _on_spawn_animal_delay_timer_timeout() -> void:
	spawn_and_throw_animal()


## Spawns an animal on a parent node... and throws it.
func spawn_and_throw_animal() -> void:
	var parent = get_parent()
	if parent == null:
		Log.error("Attempted to spawn an animal from a tornado, but the tornado doesn't have a valid parent.")
		return

	var spawned_animal: Animal = animal_scene.instantiate()
	# Spin a random position around the top of the tornado
	var thrown_position = position + Vector3(randf_range(-2, 2), randf_range(1, 3), randf_range(-2, 2))
	spawned_animal.throw(thrown_position)

	parent.add_child(spawned_animal)
