extends Node

@export var start_game_level: PackedScene
@export var level_container: Node3D
@export var ui_container: Control

var current_level: Node = null


func _ready() -> void:
	Globals.main = self
	Globals.game_state_changed.connect(func(new_game_state: Globals.GameState):
		match new_game_state:
			Globals.GameState.GAMEPLAY:
				load_level(start_game_level)
			Globals.GameState.MENU:
				unload_level()
	)


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
		Globals.time_began = Time.get_ticks_msec()
