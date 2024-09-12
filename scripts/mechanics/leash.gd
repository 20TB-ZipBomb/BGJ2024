extends Node3D
class_name Leash

static var leash_packed_scene: PackedScene = preload("res://scenes/mechanics/leash.tscn")

static var all_leashes: Array[Leash] = []
static var leashed_characters: Array[CharacterBody3D]

static var unleashed_signal: Signal = Signal()

## Anchor is the node that pulls the leashee.
static func create_leash(anchor: Node3D, leashee: Node3D) -> Leash:
	var leash: Leash = leash_packed_scene.instantiate()
	anchor.add_child(leash)
	leash.end_node = leashee
	return leash

## Removes all leashes that are pulling on a character.
static func unleash(character: CharacterBody3D) -> void:
	for leash in all_leashes:
		if leash.leashed_character == character:
			leash.queue_free()
			all_leashes.erase(leash)

## The minimum distance a character needs to be from the leash origin for it to be dragged.
@export var min_drag_distance: float = 1
@export var pull_coefficient: float = 0.7

## The node to connect to. It's owner will be dragged if it is a CharacterBody3D.
@export var end_node: Node3D:
	set(value):
		if leashed_character:
			leashed_characters.erase(leashed_character)
			leashed_character.tree_exited.disconnect(_on_leashed_character_exiting_tree)
		if value and value.owner is CharacterBody3D:
			leashed_character = value.owner
			leashed_character.tree_exiting.connect(_on_leashed_character_exiting_tree)
			leashed_characters.append(leashed_character)
		else:
			leashed_character = null
		end_node = value

var leashed_character: CharacterBody3D = null

func _on_leashed_character_exiting_tree() -> void:
	queue_free()

func _enter_tree():
	all_leashes.append(self)

func _exit_tree():
	all_leashes.erase(self)
	if leashed_character:
		var unleash_character = true
		for leash in all_leashes:
			if leash.leashed_character == leashed_character:
				unleash_character = false
		if unleash_character:
			leashed_characters.erase(leashed_character)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	look_at(end_node.global_position)
	scale.z = global_position.distance_to(end_node.global_position)
	if leashed_character and global_position.distance_to(leashed_character.global_position) > min_drag_distance:
		leashed_character.velocity = (global_position - leashed_character.global_position) * pull_coefficient
		leashed_character.move_and_slide()

## Makes the leash invisible.
func make_invisible() -> void:
	%Mesh.visible = false

## Makes the leash visible.
func make_visible() -> void:
	%Mesh.visible = true
