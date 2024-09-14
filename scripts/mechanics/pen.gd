extends Area3D
class_name PenArea

static var penned_signal: Signal = Signal()

## Invisible Leash settings
@export var min_drag_distance: float = 2
## Invisible Leash settings
@export var pull_coefficient: float = 0.2
@export var desire_type: Desire.DesireType = Desire.DesireType.NONE

@onready var feedback_sound: AudioStreamPlayer = $FeedbackAudioStreamPlayer

var penned_animals: Array[Animal] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	## When an animal touches the pen area, remove any leashes,
	## and set their Desire to DesireType.None
	print(feedback_sound)
	body_entered.connect(func(body: Node3D):
		if body is Animal and body not in penned_animals:
			var animal: Animal = body
			if animal.desire.current_desire != desire_type or animal.desire.current_desire == Desire.DesireType.NONE:
				return
			penned_animals.append(animal)
			Leash.unleash(animal)
			animal.desire.current_desire = Desire.DesireType.NONE
			PenArea.penned_signal.emit()
			if feedback_sound:
				feedback_sound.play()
			else:
				print("WARNING: Pen does not have a feedback audio stream player")
			print("Animal penned")
	)

func _process(delta: float) -> void:
	print(feedback_sound)
