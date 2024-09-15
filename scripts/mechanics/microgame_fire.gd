extends Control

@onready var watergun: Node2D = %WaterGunMouse
@onready var water_area: Area2D = %WaterArea
@onready var watergun_spray: Sprite2D = %WaterGunSpray
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var audio: AudioStreamPlayer = %AudioStreamPlayer

var spraying: bool = false
var fires_left: int = 3

func _ready() -> void:
	audio.play()
	audio.finished.connect(func():
		audio.play()
	)
	animation_player.play("new_animation")
	water_area.area_entered.connect(func(area):
		print(area)
		area.queue_free()
		fires_left -= 1
		if fires_left == 0:
			win()
	)

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		if spraying:
			return
		spraying = true
		watergun_spray.show()
		water_area.monitoring = true
		water_area.monitorable = true
		await get_tree().create_timer(0.4).timeout
		watergun_spray.hide()
		water_area.monitoring = false
		water_area.monitorable = false
		await get_tree().create_timer(0.2).timeout
		spraying = false
	
	if event is InputEventMouseMotion:
		watergun.position = event.position

func win() -> void:
	Globals.microgame_completed.emit()
	queue_free()
