extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	Globals.game_state_changed.connect(func(new_game_state: Globals.GameState):
		match new_game_state:
			Globals.GameState.GAME_OVER:
				show()
			Globals.GameState.GAMEPLAY:
				hide()
			Globals.GameState.MENU:
				hide()
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
