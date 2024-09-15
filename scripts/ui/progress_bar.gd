class_name GameProgressBar
extends Control

@onready var progress_bar: TextureProgressBar = %TextureProgressBar

#how much time remains until death
var progress_bar_value: float = 75.0
var max_progress_bar_value: float = 100.0

func _ready():
	Globals.animal_penned_signal.connect(func(obj):
		progress_bar_value += 25
	)

func set_progressbar(percentage: float):
	progress_bar.value = percentage

func _process(delta: float) -> void:
	progress_bar_value -= delta
	
	set_progressbar(progress_bar_value / max_progress_bar_value)
	
	#insert check for gameover somewhere here (i guess?)
