extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.game_state_changed.connect(func(new_game_state: Globals.GameState):
		match new_game_state:
			Globals.GameState.MENU:
				hide()
			Globals.GameState.GAMEPLAY:
				show()
			Globals.GameState.GAME_OVER:
				queue_free()
	)
