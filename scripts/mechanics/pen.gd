extends Area3D
class_name PenArea

@export var desire_type: Desire.DesireType = Desire.DesireType.NONE
@export var feedback_sound: AudioStreamPlayer

@export var microgame_feed: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	## When an animal touches the pen area, remove any leashes,
	## and set their Desire to DesireType.None
	body_entered.connect(func(body: Node3D):
		if Globals.game_state == Globals.GameState.GAME_OVER:
			return
			
		if body is Animal:
			var animal: Animal = body
			if animal.desire.current_desire != desire_type or animal.desire.current_desire == Desire.DesireType.NONE:
				return
			
			Globals.micrograme_queue.append(microgame_feed)
			Globals.load_next_microgame()
			
			Leash.unleash(animal)
			animal.desire.current_desire = Desire.DesireType.NONE
			Globals.animal_penned_signal.emit(animal)
			if feedback_sound:
				feedback_sound.play()
			else:
				print("WARNING: Pen does not have a feedback audio stream player")
			print("Animal penned")
	)
