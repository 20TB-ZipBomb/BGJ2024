extends Node

# Global script for holding references to things and stuff
const PENNED_ANIMAL_HP_RESTORE: float = 5 ## Seconds
const PENNED_ANIMAL_HP_RESTORE_PER_COMBO: float = 0.5 ## Adds 0.5s per combo

const MAX_HP: float = 30
var main: Node
var player: CharacterBody3D
signal animal_penned_signal(animal: Animal)

var time_began: int = 0 ## Engine ms timestamp

signal game_state_changed(new_game_state: GameState)

enum GameState {
	MENU,
	GAMEPLAY,
	GAME_OVER,
}

var game_state: GameState = GameState.MENU:
	set(value):
		if game_state != value:
			game_state = value
			game_state_changed.emit(game_state)

func _on_game_state_changed(new_game_state: GameState) -> void:
	match new_game_state:
		GameState.MENU:
			pass
		GameState.GAMEPLAY:
			time_began = Time.get_ticks_msec()
		GameState.GAME_OVER:
			pass

## Current wave number, used for balancing storm behavior and animals spawned
var current_storm_wave_number: int
## Current combo number, used for combo'ing on the cow progress bar
var current_combo_number: int


signal shout_energy_changed(value: float) # set shout energy. 0 is no shout, 1 is shout ready
