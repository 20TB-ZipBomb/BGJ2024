extends Node
class_name Desire

## General list of desires for each animal.
## @NOTE: These combine desires that are considered 'general' (thirsty, hungry, etc.)
## and those that are 'storm-specific' for the time-being.
enum DesireType {
	NONE,
	RED_PEN,
	BLUE_PEN,
	GREEN_PEN,
	YELLOW_PEN,
	#THIRSTY,
	#INJURED,
	#HUNGRY,
	#WET,
	#SHOCKED,
	#BURNING,
}

## The animal sprite being updated with desire colors.
@export var animal_sprite: Sprite3D = null
## Maps the desires for each animal to a particular color.
###
## In an ideal, forgiving, and graceful world - we could efficiently set these all in the scene, and not in code.
## https://github.com/godotengine/godot/pull/78656
## (╯°□°)╯︵ ┻━┻
@export var desire_to_color_map: Dictionary = {
	DesireType.NONE: Color.WHITE,
	DesireType.RED_PEN: Color.RED,
	DesireType.BLUE_PEN: Color.BLUE,
	DesireType.GREEN_PEN: Color.GREEN,
	DesireType.YELLOW_PEN: Color.YELLOW,
	#DesireType.THIRSTY: Color.GREEN,
	#DesireType.INJURED: Color.PINK,
	#DesireType.HUNGRY: Color.SADDLE_BROWN,
	#DesireType.WET: Color.BLUE,
	#DesireType.SHOCKED: Color.YELLOW,
	#DesireType.BURNING: Color.FIREBRICK,
}

## String representation for the current desire.
## This is readonly, and updating it will have no impact.
@export var _current_desire_string = ""
var current_desire: DesireType = DesireType.NONE:
	set(value):
		if value != current_desire:
			current_desire = value
			desire_changed.emit(current_desire)

@export var burning_particles: GPUParticles3D

signal desire_changed(new_desire: DesireType)

func _ready() -> void:
	desire_changed.connect(_on_desire_changed)
	roll_new_desire()

## Randomly assigns a new desire
func roll_new_desire() -> void:
	var rng = RandomNumberGenerator.new()
	var random_desire_type: DesireType = DesireType.values().pick_random()
	if not desire_to_color_map.has(random_desire_type):
		print_debug("Attempted to set a desire ", DesireType.keys()[random_desire_type], " but it doesn't have a valid color set")
		return

	# Update the current desire and its string
	current_desire = random_desire_type
	_current_desire_string = DesireType.keys()[current_desire]

## Sets the color of the current sprite based on the provided desire
func _on_desire_changed(new_desire: DesireType) -> void:
	if animal_sprite:
		# Modulate the sprite based on the color associated with the desire
		animal_sprite.modulate = desire_to_color_map[new_desire]
	else:
		print_debug("The animal sprite is not set, no sprites will have their colors updated")
	
	match new_desire:
		DesireType.RED_PEN:
			burning_particles.emitting = true
		_:
			burning_particles.emitting = false
			pass

	# Modulate the sprite based on the color associated with the desire
	animal_sprite.material_override.set_shader_parameter("new_color", desire_to_color_map[current_desire])
