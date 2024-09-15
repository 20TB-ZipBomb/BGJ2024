extends Control

@onready var bluespot: Node2D = %BlueSpot
@onready var redspot: Node2D = %RedSpot
@onready var jumper_red: Sprite2D = %JumperCableRed
@onready var jumper_blue: Sprite2D =  %JumperCableBlue
@onready var jumpercow_red: Sprite2D = %JumperCableRed_Cow
@onready var jumpercow_blue: Sprite2D =  %JumperCableBlue_Cow

var pickedupred: bool = false
var pickedupblue: bool = false
var cable_dist_tolerance: float = 15
var battery_dist_tolerance: float = 5

var cables_connected: float = 0

func _draw():
	#blue
	draw_line(jumpercow_blue.position, jumper_blue.position , Color(0, 0, 1), 3)
	
	#red
	draw_line(jumpercow_red.position, jumper_red.position , Color(1, 0, 0), 3)

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		print("Mouse Click/Unclick at: ", event.position)
		
		if (pickedupred == false):
			if(pickedupblue == true):
				return
			
			var dist = event.position.distance_to(jumper_red.position)
			
			if (dist < cable_dist_tolerance):
				pickedupred = true
				return
		
		if(pickedupblue == false):
			if (pickedupred == true):
				return
				
			var dist = event.position.distance_to(jumper_blue.position)
			
			if (dist < cable_dist_tolerance):
				pickedupblue = true
				return
				
	elif event is InputEventMouseMotion:
		if (pickedupred == true):
			jumper_red.position = event.position
			
			var dist = event.position.distance_to(redspot.position)
			
			if (dist < battery_dist_tolerance):
				pickedupred = false
				cables_connected += 1
				
		elif (pickedupblue == true):
			jumper_blue.position = event.position
			
			var dist = event.position.distance_to(bluespot.position)
			
			if (dist < battery_dist_tolerance):
				pickedupblue = false
				cables_connected += 1
		queue_redraw()

	if (cables_connected >= 2):
		Globals.microgame_completed.emit()
		queue_free()
