extends Node

@export var level_container: Node2D
@export var ui_container: Control

var current_level: Node = null

func _ready() -> void:
	Globals.main = self

func unload_level() -> void:
	if is_instance_valid(current_level):
		current_level.queue_free()
	current_level = null
	
func load_level(level: PackedScene) -> void:
	unload_level()
	var level_scene: PackedScene = load(level.get_path())
	
	if level_scene:
		current_level = level_scene.instantiate()
		level_container.add_child(current_level)
