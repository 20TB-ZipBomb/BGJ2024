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
var current_desire: DesireType = DesireType.NONE


func _ready() -> void:
	roll_new_desire_and_update_sprite()


## Sets the color of the current sprite based on the provided desire
func roll_new_desire_and_update_sprite() -> void:
	if not animal_sprite:
		print_debug("The animal sprite is not set, no sprites will have their colors updated")
		return

	var rng = RandomNumberGenerator.new()
	var random_desire_type: DesireType = DesireType.values().pick_random() #rng.randi_range(0, DesireType.MAX - 1) as DesireType
	if not desire_to_color_map.has(random_desire_type):
		print_debug("Attempted to set a desire ", DesireType.keys()[random_desire_type], " but it doesn't have a valid color set")
		return

	# Update the current desire and its string
	current_desire = random_desire_type
	_current_desire_string = DesireType.keys()[current_desire]

	# Modulate the sprite based on the color associated with the desire
	animal_sprite.modulate = desire_to_color_map[current_desire]
