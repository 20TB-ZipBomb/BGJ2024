extends Control

@export var start_game_level: PackedScene
@export var audio_stream: AudioStreamPlayer
@onready var start_game: Button = %StartGame
@onready var quit_game: Button = %QuitGame


var is_hovering: bool = false

func _on_start_game_pressed() -> void:
	Globals.main.load_level(start_game_level)
	self.hide()

func _on_quit_game_pressed() -> void:
	get_tree().quit()

func _on_start_game_mouse_entered() -> void:
	play_hover_audio()

func _on_quit_game_mouse_entered() -> void:
	play_hover_audio()

func play_hover_audio() -> void:
	audio_stream.stream = preload("res://assets/audio/sfx/menu select.wav")
	audio_stream.play()
