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

@onready var move_path: Path3D = $TornadoMovePath
@onready var path_follow: PathFollow3D = $TornadoMovePath/TornadoSpawnLocation

var curved_num_animals_to_spawn: int = 0
static var generated_curves: Array[String] = []


static func _static_init() -> void:
	# Select a random tornado path for this tornado
	generated_curves = FileHelper.get_files_in_directory(CurveGenerator.CURVE_GENERATOR_OUTPUT_DIR)


func _ready() -> void:
	hide()
	setup_random_generated_curve_for_path()
	
	# Determine the number of cows to spawn using the current wave number,
	# the maximum number of cows per storm, and the difficulty curve
	# @TODO: Port this logic for the tornado spawning... I think?
	var sample_point: float = float(Globals.current_storm_wave_number) / float(max_number_of_storms_before_max_difficulty)
	curved_num_animals_to_spawn = floor(storm_difficulty_curve.sample(sample_point))


func _process(delta: float) -> void:
	path_follow.progress_ratio += tornado_speed * delta
	position = path_follow.position
	# After first update, turn the visibility on
	visible = true


## When the despawn timer is triggered, remove this tornado from the level
func _on_despawn_timer_timeout() -> void:
	queue_free()


## When the animal spawn timer is triggered, throw an animal out near the tornado.
func _on_spawn_animal_delay_timer_timeout() -> void:
	spawn_and_throw_animal()


## Selects a random file in `CurveGenerator.CURVE_GENERATOR_OUTPUT_DIR` and assigns it as this tornado's movement path.
## Also initializes the progress ratio to the start of the path. 
func setup_random_generated_curve_for_path() -> void:
	var generated_curve_index = randi_range(0, generated_curves.size() - 1)
	var generated_curve_resource_path = CurveGenerator.CURVE_GENERATOR_OUTPUT_DIR + generated_curves[generated_curve_index]
	move_path.curve = ResourceLoader.load(generated_curve_resource_path) as Curve3D
	
	# Initialize the tornado in a random position on its path
	path_follow.progress_ratio = 0


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
