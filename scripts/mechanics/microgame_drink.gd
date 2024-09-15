extends Control

@onready var droplet1: Sprite2D = %Droplet1
@onready var droplet2: Sprite2D = %Droplet2
@onready var droplet3: Sprite2D = %Droplet3
@onready var droplet4: Sprite2D = %Droplet4
@onready var cow_mouth: Node2D = %CowMouth
@onready var progress: ProgressBar = %ProgressBar

var dist: float = 15

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		print("Mouse Click/Unclick at: ", event.position)
		if droplet1.visible and event.position.distance_to(droplet1.position) < dist:
			droplet1.visible = false
			progress.value += 25
		elif droplet2.visible and event.position.distance_to(droplet2.position) < dist:
			droplet2.visible = false
			progress.value += 25
		elif droplet3.visible and event.position.distance_to(droplet3.position) < dist:
			droplet3.visible = false
			progress.value += 25
		elif droplet4.visible and event.position.distance_to(droplet4.position) < dist:
			droplet4.visible = false
			progress.value += 25
		
		if progress.value >= 100:
			Globals.microgame_completed.emit()
			queue_free()
				
