class_name PlayerController
extends CharacterBody3D

@export var shout_cooldown: float = 5 # Seconds
@export var speed: float = 4
## The player's speed is multiplied by this number to the power of the number of leashed_animals.
## This lets the player can leash as many animals as they want without completely stopping.
@export_range(0, 1) var speed_reduction_per_dragged_body: float = 0.85

@export var lasso_range: float = 3

@onready var raycast: RayCast3D = %RayCast3D
@onready var leash_point: Node3D = %LeashPoint
@onready var shout_area: Area3D = %ShoutArea
@onready var foostep_sound: AudioStreamPlayer = %FootstepsStreamPlayer
@onready var shout_sound: AudioStreamPlayer = %ShoutStreamPlayer
@onready var lasso_attach_sound: AudioStreamPlayer = %LassoAttachStreamPlayer
@onready var lasso_detach_sound: AudioStreamPlayer = %LassoDetachStreamPlayer
@onready var dust_particles: GPUParticles3D = %DustTrailParticles

## Can be null when not targetting any animal
var targeted_animal: Animal:
	set(value):
		if targeted_animal:
			targeted_animal.hide_lasso()
		targeted_animal = value
		if targeted_animal:
			targeted_animal.show_lasso()

var dragged_animal_count: int = 0
var current_shout_cooldown: float = 0

func _ready() -> void:
	Globals.player = self

func _physics_process(_delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if direction.length() > 0:
		var raycast_direction: Vector2 = direction.normalized() * lasso_range
		raycast.target_position = Vector3(raycast_direction.x, 0, raycast_direction.y)
		if not foostep_sound.playing:
			foostep_sound.play()
			dust_particles.emitting = true
	else:
		if foostep_sound.playing:
			foostep_sound.stop()
			dust_particles.emitting = false
	
	# Handle targetting and leashing of animals
	var body: Area3D = raycast.get_collider()
	if body and body.owner is Animal and body.owner not in Leash.leashed_characters and body.owner.desire.current_desire != Desire.DesireType.NONE:
		targeted_animal = body.owner
		if Input.is_action_just_pressed("use_leash"):
			var leash: Leash = Leash.create_leash(leash_point, targeted_animal.leash_point)
			dragged_animal_count += 1
			lasso_attach_sound.play()
			leash.tree_exiting.connect(func():
				dragged_animal_count -= 1
			)
	else:
		targeted_animal = null
		
	var movement_vector: Vector2 = direction * (speed * pow(speed_reduction_per_dragged_body, dragged_animal_count))
	velocity = Vector3(movement_vector.x, 0, movement_vector.y)
	move_and_slide()

func _process(delta: float):
	current_shout_cooldown += delta
	Globals.shout_energy_changed.emit(clampf(current_shout_cooldown / shout_cooldown, 0, 1))
	if Input.is_action_just_pressed("shout") and current_shout_cooldown >= shout_cooldown:
		var bodies = shout_area.get_overlapping_bodies()
		for body in bodies:
			if body is Animal:
				body.scare(global_position)
		current_shout_cooldown = 0
		var camera_shaker: CameraShaker = $CameraShaker
		if camera_shaker:
			camera_shaker.apply_shake()
		shout_sound.play()
	if Input.is_action_just_pressed("remove_leash"):
		lasso_detach_sound.play()
		for leash in Leash.all_leashes:
			leash.queue_free()
