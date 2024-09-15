extends Node3D


@export_category("Combo Number Settings")
@export var critical_color: Color = "#B22"
@export var normal_color: Color = "#FFF8"
@export var font: Font = null

@onready var combo_dead_timer = %ComboDeadTimer


func _ready() -> void:
	Globals.animal_penned_signal.connect(func(_obj): handle_combo())
	

## Reset the global combo number to 0
func _on_combo_dead_timer_timeout() -> void:
	Globals.current_combo_number = 0
	
	
func handle_combo():
	# Start the combo timer if the combo is at 0, otherwise restart the timer each time an animal is penned
	if Globals.current_combo_number == 0:
		combo_dead_timer.start()
	else:
		combo_dead_timer.stop()
		combo_dead_timer.start()
		
	Globals.current_combo_number += 1
	var unprojected_position = get_viewport().get_camera_3d().unproject_position(global_position)
	display_number(Globals.current_combo_number, unprojected_position)


## Displays the combo number with the provided value at the provided position.
func display_number(value: int, pos: Vector2):
	var is_critical = value > 10
	
	var number = Label.new()
	number.global_position = pos
	number.text = "x %s" % str(value)
	number.z_index = 5
	
	number.label_settings = LabelSettings.new()
	number.label_settings.font = font
	number.label_settings.font_color = critical_color if is_critical else normal_color
	number.label_settings.font_size = 8
	number.label_settings.outline_color = "#000"
	number.label_settings.outline_size = 1
	
	# Add the number label as a child
	call_deferred("add_child", number)
	
	await number.resized
	number.pivot_offset = Vector2(number.size / 2)
	
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	# Make the number animate going up by 24 pixels in 0.25s
	tween.tween_property(number, "position:y", number.position.y - 24, 0.25).set_ease(Tween.EASE_OUT)
	var _sign = 1 if randi() % 2 else -1
	tween.tween_property(number, "rotation", _sign * PI / 4, 0.75)
	# Make it go back down
	tween.tween_property(number, "position:y", number.position.y, 0.5).set_ease(Tween.EASE_IN).set_delay(0.25)
	tween.tween_property(number, "scale", Vector2.ZERO, 0.25).set_ease(Tween.EASE_IN).set_delay(0.5)
	
	# Wait for the tween to finish and destroy it
	await tween.finished
	number.queue_free()
