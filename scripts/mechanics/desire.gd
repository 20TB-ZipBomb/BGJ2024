extends Node
class_name Desire

enum DesireTypes {
	NONE,
	THIRSTY,
	INJURED,
	HUNGRY,
	WET,
	SHOCKED,
	BURNING,
}

## The animal sprite being updated with desire colors.
@export var animal_sprite: Sprite3D = null
## Maps the desires for each animal to a particular color.
@export var desire_to_color_map: Dictionary = {
	DesireTypes.NONE: Color.WHITE,
	DesireTypes.THIRSTY: Color.GREEN,
	DesireTypes.INJURED: Color.PINK,
	DesireTypes.HUNGRY: Color.SADDLE_BROWN,
	DesireTypes.WET: Color.BLUE,
	DesireTypes.SHOCKED: Color.YELLOW,
	DesireTypes.BURNING: Color.FIREBRICK,
}

## String representation for the current desire. 
## This is readonly, and updating it will have no impact.
@export var _current_desire_string = ""
var current_desire: DesireTypes = DesireTypes.NONE


func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	var desires = desire_to_color_map.keys()
	var rand = rng.randi_range(0, len(desire_to_color_map) - 1)
	update_sprite_color_with_desire(desires[rand])


## Sets the color of the current sprite based on the provided desire
func update_sprite_color_with_desire(new_desire: DesireTypes) -> void:
	if not animal_sprite:
		print_debug("The animal sprite is not set, no sprites will have their colors updated")
		return
		
	if not desire_to_color_map.has(new_desire):
		print_debug("Attempted to set a desire ", new_desire, " but it doesn't have a valid color set")
		return
	
	# Update the current desire and modulate the sprite based on it
	current_desire = new_desire
	_current_desire_string = DesireTypes.keys()[current_desire]
	animal_sprite.modulate = desire_to_color_map[current_desire]
