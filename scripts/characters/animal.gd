extends CharacterBody3D
class_name Animal

@export var desire: Desire
@export var wander_speed: float = 0.5
@export var scared_speed: float = 1.0
@export var throw_intensity: float = 20.0
@export var scared_duration: float = 3.0 ## How long the animal will be scared for

@onready var lasso_icon: Sprite3D = %LassoIcon
@onready var leash_point: Node3D = %LeashPoint

enum State {
	WANDERING,
	SCARED,
	THROWN
}

var state: State = State.WANDERING
var wander_vector: Vector2 = Vector2.DOWN
var is_thrown: bool = false

func _ready() -> void:
	hide_lasso()

func show_lasso() -> void:
	lasso_icon.show()

func hide_lasso() -> void:
	lasso_icon.hide()

## Scares an animal. Provide the global_position of where they should run away from
func scare(scare_origin: Vector3) -> void:
	var scare_direction: Vector3 = (global_position - scare_origin).normalized()
	wander_vector = Vector2(scare_direction.x, scare_direction.z)
	state = State.SCARED
	get_tree().create_timer(scared_duration).timeout.connect(func():
		state = State.WANDERING
	)

## Throws the animal, used to spawn the animal from a tornado
func throw(throwing_position: Vector3) -> void:
	position = throwing_position
	state = State.THROWN
	is_thrown = true

func _physics_process(delta):
	match state:
		State.WANDERING:
			var _sign = ((randi() % 2) - 0.5) * 2
			wander_vector = wander_vector.rotated(_sign * delta * 3)
			velocity = Vector3(wander_vector.x, 0, wander_vector.y).normalized() * wander_speed
		State.SCARED:
			var _sign = ((randi() % 2) - 0.5) * 2
			wander_vector = wander_vector.rotated(_sign * delta * 3)
			velocity = Vector3(wander_vector.x, 0, wander_vector.y).normalized() * scared_speed
		State.THROWN:
			var _sign = ((randi() % 2) - 0.5) * 2
			wander_vector = wander_vector.rotated(_sign * delta * 3)
			velocity = Vector3(wander_vector.x, 0, wander_vector.y).normalized() * (_sign * throw_intensity)
	if not is_on_floor():
		velocity += get_gravity()
	if is_on_floor() and is_thrown:
		is_thrown = false
		state = State.WANDERING
	move_and_slide()
