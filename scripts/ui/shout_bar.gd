class_name ShoutProgressBar
extends Control

@onready var label: Label = %Label
@onready var progress_bar: ProgressBar = %ProgressBar

func _ready():
	Globals.shout_energy_changed.connect(set_progress)

func set_progress(percentage: float):
	progress_bar.value = percentage
	if percentage < 1:
		label.text = "Charging..."
	else:
		label.text = "SHOUT!"
