class_name ShoutProgressBar
extends Control

@onready var label: Label = %Label
@onready var progress_bar: TextureProgressBar = %TextureProgressBar
@onready var filled_sound: AudioStreamPlayer = %FilledSound

var has_full_charge_sound_played: bool = false

func _ready():
	Globals.shout_energy_changed.connect(set_progress)

func set_progress(percentage: float):
	progress_bar.value = percentage
	if percentage < 1:
		label.text = "Charging..."
		has_full_charge_sound_played = false
	else:
		label.text = "SHOUT!"
		if not has_full_charge_sound_played:
			filled_sound.play()
			has_full_charge_sound_played = true
