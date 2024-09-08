extends CharacterBody2D


@export var speed: float = 300.0
@export var jump_velocity: float = -400.0

func _ready() -> void:
	Globals.player = self

func _physics_process(_delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed

	move_and_slide()
