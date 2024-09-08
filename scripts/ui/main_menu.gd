extends Control

@export var start_game_level: PackedScene

func _on_start_game_pressed() -> void:
	Globals.main.load_level(start_game_level)
	self.hide()


func _on_quit_game_pressed() -> void:
	get_tree().quit()
