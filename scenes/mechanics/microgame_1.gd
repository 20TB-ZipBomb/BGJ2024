extends Control

@onready var apple: Sprite2D = %Apple
@onready var cow_mouth: Node2D = %CowMouth
@onready var cow: Sprite2D = %Cowcloseup

var happy_cow: Texture2D = preload("res://assets/characters/cowcloseup2.png")

var pickedup: bool = false
var apple_dist_tolerance: float = 15
var mouth_dist_tolerance: float = 15

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		print("Mouse Click/Unclick at: ", event.position)
		
		if (pickedup == false):
			var dist = event.position.distance_to(apple.position)
			
			if (dist < apple_dist_tolerance):
				pickedup = true
				
	elif event is InputEventMouseMotion:
		if (pickedup == true):
			apple.position = event.position
			
			var dist = event.position.distance_to(cow_mouth.position)
			
			if (dist < mouth_dist_tolerance):
				pickedup = false
				cow.texture = happy_cow
				Globals.microgame_completed.emit()
				queue_free()
