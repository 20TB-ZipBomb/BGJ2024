extends Control

@onready var return_button: Button = %ReturnButton
@onready var time_label: Label = %Time
@onready var jingle_sound: AudioStreamPlayer = %JingleStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	Globals.game_state_changed.connect(func(new_game_state: Globals.GameState):
		match new_game_state:
			Globals.GameState.GAME_OVER:
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
				time_label.text = "YOUR TIME: " + text_string
				jingle_sound.play()
				show()
			Globals.GameState.GAMEPLAY:
				hide()
			Globals.GameState.MENU:
				hide()
	)
	return_button.pressed.connect(func():
		Globals.game_state = Globals.GameState.MENU
	)
