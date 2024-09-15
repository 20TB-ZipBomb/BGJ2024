extends Control

@export var audio_stream: AudioStreamPlayer
@onready var start_game: Button = %StartGame
@onready var quit_game: Button = %QuitGame

var is_hovering: bool = false
var button_down = false
@onready var tex = preload("res://assets/ui/button-2-press.png")
var stylebox_override = StyleBoxTexture.new()

func _init() -> void:
	stylebox_override.texture = tex
	stylebox_override.set_expand_margin(SIDE_TOP, 5)
	stylebox_override.set_expand_margin(SIDE_BOTTOM, 5)
	stylebox_override.set_content_margin(SIDE_TOP, 5)

func _ready() -> void:
	Globals.game_state_changed.connect(func(new_game_state: Globals.GameState):
		match new_game_state:
			Globals.GameState.MENU:
				self.show()
			Globals.GameState.GAMEPLAY:
				self.hide()
			Globals.GameState.GAME_OVER:
				self.hide()
	)
	
func _on_start_game_pressed() -> void:
	Globals.game_state = Globals.GameState.GAMEPLAY

func _on_quit_game_pressed() -> void:
	get_tree().quit()

func _on_start_game_button_down() -> void:
	button_down = true
	start_game.add_theme_stylebox_override("pressed", stylebox_override)


func _on_start_game_button_up() -> void:
	button_down = false
	start_game.remove_theme_stylebox_override("pressed")


func _on_start_game_mouse_exited() -> void:
	start_game.remove_theme_stylebox_override("pressed")


func _on_start_game_mouse_entered() -> void:
	play_hover_audio()
	if button_down == true:
		start_game.add_theme_stylebox_override("pressed", stylebox_override)

func _on_quit_game_button_down() -> void:
	button_down = true
	quit_game.add_theme_stylebox_override("pressed", stylebox_override)


func _on_quit_game_button_up() -> void:
	button_down = false
	quit_game.remove_theme_stylebox_override("pressed")


func _on_quit_game_mouse_entered() -> void:
	play_hover_audio()
	if button_down == true:
		quit_game.add_theme_stylebox_override("pressed", stylebox_override)


func _on_quit_game_mouse_exited() -> void:
	quit_game.remove_theme_stylebox_override("pressed")


func play_hover_audio() -> void:
	audio_stream.stream = load("res://assets/audio/sfx/menu select.wav")
	audio_stream.play()
