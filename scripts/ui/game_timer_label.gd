extends Label

var ticking: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.game_state_changed.connect(func(new_game_state: Globals.GameState):
		match new_game_state:
			Globals.GameState.MENU:
				ticking = false
				hide()
			Globals.GameState.GAMEPLAY:
				ticking = true
				show()
			Globals.GameState.GAME_OVER:
				ticking = false
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ticking:
		var ms_elapsed: int = Globals.time_began - Time.get_ticks_msec()
		var minutes: int = ms_elapsed / 60
		var seconds: int = ms_elapsed % 60
		text = str(minutes) + ":" + str(seconds)
