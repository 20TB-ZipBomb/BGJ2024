extends Control

@export var start_game_level: PackedScene
@onready var start_game_but = $PanelContainer/VBoxContainer/HBoxContainer/Buttons/StartGame
@onready var quit_game_but = $PanelContainer/VBoxContainer/HBoxContainer/Buttons/QuitGame

var button_down = false
var tex = load("res://assets/button-2-press.png")
var stylebox_override = StyleBoxTexture.new()


func _init() -> void:
	stylebox_override.texture = tex
	stylebox_override.set_expand_margin(SIDE_TOP, 15)
	stylebox_override.set_expand_margin(SIDE_BOTTOM, 15)
	stylebox_override.set_content_margin(SIDE_TOP, 30)


func _on_start_game_pressed() -> void:
	Globals.main.load_level(start_game_level)
	self.hide()


func _on_quit_game_pressed() -> void:
	get_tree().quit()


func _on_start_game_button_down() -> void:
	button_down = true
	start_game_but.add_theme_stylebox_override("pressed", stylebox_override)


func _on_start_game_button_up() -> void:
	button_down = false
	start_game_but.remove_theme_stylebox_override("pressed")


func _on_start_game_mouse_exited() -> void:
	start_game_but.remove_theme_stylebox_override("pressed")


func _on_start_game_mouse_entered() -> void:
	if button_down == true:
		start_game_but.add_theme_stylebox_override("pressed", stylebox_override)

func _on_quit_game_button_down() -> void:
	button_down = true
	quit_game_but.add_theme_stylebox_override("pressed", stylebox_override)


func _on_quit_game_button_up() -> void:
	button_down = false
	quit_game_but.remove_theme_stylebox_override("pressed")


func _on_quit_game_mouse_exited() -> void:
	quit_game_but.remove_theme_stylebox_override("pressed")


func _on_quit_game_mouse_entered() -> void:
	if button_down == true:
		quit_game_but.add_theme_stylebox_override("pressed", stylebox_override)
