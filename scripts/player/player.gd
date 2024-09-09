class_name PlayerController
extends CharacterBody2D

@export var shout_cooldown: float = 5 # Seconds
@export var speed: float = 80.0
@export var speed_reduction_per_dragged_body: float = 10.0
## The minimum distance an animal needs to be from the player for it to be dragged while being lassoed.
@export var min_drag_distance: float = 20 # Measured in pixels
@export var lasso_range: float = 50 # Measured in pixels
## The amount of time you have to target an animal after you stop targetting it. Measured in seconds.
@export var lasso_grace_period: float = 0.2

@onready var raycast: RayCast2D = %RayCast2D
@onready var reticle: Sprite2D = %Reticle

var dragged_bodies: Array[CharacterBody2D] = []
var current_shout_cooldown: float = 0

func _ready() -> void:
	Globals.player = self

func _physics_process(_delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if direction.length() > 0:
		raycast.target_position = direction.normalized() * lasso_range
	
	# Handle targetting and lassoing of animals
	var body: Area2D = raycast.get_collider()
	if body and body is Area2D and body.owner not in dragged_bodies:
		reticle.visible = true
		reticle.global_position = body.global_position
		if Input.is_action_just_pressed("use_lasso"):
			dragged_bodies.append(body.owner)
	else:
		reticle.visible = false
		
	
	velocity = direction * clampf(speed - (dragged_bodies.size() * speed_reduction_per_dragged_body), 0, speed)
	move_and_slide()
	
	# Drag lassoed animals
	for collision_object: CharacterBody2D in dragged_bodies:
		if global_position.distance_to(collision_object.global_position) > min_drag_distance:
			collision_object.velocity = (global_position - collision_object.global_position) * 0.7
			collision_object.move_and_slide()

func _process(delta: float):
	current_shout_cooldown += delta
	Globals.shout_energy.emit(clampf(current_shout_cooldown / shout_cooldown, 0, 1))
	if Input.is_action_just_pressed("shout") and current_shout_cooldown >= shout_cooldown:
		Globals.shout.emit(global_position)
		current_shout_cooldown = 0
		print("Shouted")
	
