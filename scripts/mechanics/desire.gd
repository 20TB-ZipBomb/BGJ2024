extends Node

class_name Desire

enum DesireType {NONE, HUNGRY, INJURED, THIRSTY, BURNING}

const DESIRE_COLOR_MAP = {
	DesireType.NONE: Color("white"),
	DesireType.HUNGRY: Color("blue"),
	DesireType.THIRSTY: Color("green"),
	DesireType.BURNING: Color("red")
}

@export var sprite_node_type = "AnimalSprite"

var current_desire = DesireType.NONE

var sprite = null

func set_desire(new_desire) -> void:
	# unsure if there is a better method to ensure type of param
	if new_desire is not DesireType:
		print_debug(new_desire, "is not a desire type")
		pass
	current_desire = new_desire
	if sprite:
		#material.set_shader_parameter("selected_color", DESIRE_COLOR_MAP[new_desire])
		sprite.modulate = DESIRE_COLOR_MAP[new_desire]
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite = get_node("../Tilt/" + sprite_node_type)
	var rng = RandomNumberGenerator.new()
	var desires = DESIRE_COLOR_MAP.keys()
	set_desire(desires[rng.randi_range(0,3)])
