extends Label

var ticking: bool = true

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
func _process(_delta: float) -> void:
	if ticking:
		var seconds_elapsed: int = (Time.get_ticks_msec() - Globals.time_began) / 1000
		var minutes: int = seconds_elapsed / 60
		var seconds: int = seconds_elapsed % 60
		
		var text_string: String = ""
		if minutes < 10:
			text_string += "0"
		text_string += str(minutes)
		text_string += ":"
		if seconds < 10:
			text_string += "0"
		text_string += str(seconds)
		text = text_string
