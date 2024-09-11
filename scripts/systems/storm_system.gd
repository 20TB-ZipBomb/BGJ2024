extends Node
class_name StormSystem

## Represents the possible types of storms.
enum StormType {
	NONE,
	RAIN,
	FIRE,
	LIGHTNING,
	ALL,
}

## The scene spawned for animals.
## @TODO: Implement for multiple animals?
@export_category("Animal")
@export var animal_scene: PackedScene = null
@export_category("Storm Metrics")
## Maximum number of storms to incur before the difficulty curve peaks.
@export var max_number_of_storms_before_max_difficulty: int = 10
## Difficulty curve for the number of animals being spawned in each wave.
##
## The x-axis for the curve represents the percentage of rounds completed based on `max_number_of_storms` 
## and the y-axis represents the number of animals to spawn in.
@export var storm_difficulty_curve: Curve = null

@onready var animal_spline: PathFollow3D = $SpawnPath/SpawnLocation

## Current wave number
var storm_wave_number: int = 0
## Indicates whether the next storm of animals are ready to be spawned
var next_wave_is_ready: bool = true
## @TODO: Type for the next storm
var current_storm_type: StormType = StormType.NONE


func _process(_delta: float) -> void:
	try_spawn_next_storm()


## Signal fired whenever the StormTimer ticks.
func _on_storm_timer_timeout() -> void:
	# Spin for a random point on the spline
	animal_spline.progress_ratio = randf()

	# Set the flag to spawn the next wave. We do this because the `update_transform` for the spline 
	# seems to be deferred to it's next tick. If we use the current position right after setting 
	# `progress_ratio` it will always use it's previous position.
	#
	# Reference: https://github.com/godotengine/godot/blob/97ef3c837263099faf02d8ebafd6c77c94d2aaba/scene/3d/path_3d.cpp#L219
	next_wave_is_ready = true


func try_spawn_next_storm() -> void:
	if not next_wave_is_ready:
		return

	# Increment the wave number
	storm_wave_number += 1
	# Turn off the wave ready flag
	next_wave_is_ready = false

	# Set the type for this storm
	# @TODO: Need to determine how this will impact the wave being spawned and the behavior of the animals
	var rng = RandomNumberGenerator.new()
	current_storm_type = rng.randi_range(StormType.NONE, StormType.ALL - 1) as StormType

	# Determine the number of cows to spawn using the current wave number,
	# the maximum number of cows per storm, and the difficulty curve
	var sample_point: float = float(storm_wave_number) / float(max_number_of_storms_before_max_difficulty)
	var curved_num_animals_to_spawn: int = floor(storm_difficulty_curve.sample(sample_point))

	# Spawn the group of animals at the set point on the spline
	for _i in curved_num_animals_to_spawn:
		var animal: Animal = animal_scene.instantiate()
		animal.position = animal_spline.position + Vector3(randf(), 0, randf())
		add_child(animal)
