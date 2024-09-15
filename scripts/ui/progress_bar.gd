class_name GameProgressBar
extends Control

@onready var progress_bar: TextureProgressBar = %TextureProgressBar

#how much time remains until death
var progress_bar_value: float = Globals.MAX_HP

func _ready():
	Globals.animal_penned_signal.connect(func(obj):
		progress_bar_value = clampf(progress_bar_value + Globals.PENNED_ANIMAL_HP_RESTORE, 0, Globals.MAX_HP)
	)

func set_progressbar(percentage: float):
	progress_bar.value = percentage

func _process(delta: float) -> void:
	progress_bar_value -= delta
	
	set_progressbar(progress_bar_value / Globals.MAX_HP)
	
	if progress_bar_value <= 0:
		Globals.game_state = Globals.GameState.GAME_OVER
