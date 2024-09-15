extends Sprite3D

@export var frequency: float = 6.0
@export var duration: float = 0.4

@export var animal: Animal = null
@export var desire: Desire = null

# every X seconds, poll the desire and animal state and pick an appropriate moodlet
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var timer = $MoodletUpdateTimer
	timer.wait_time = frequency
	var rng = RandomNumberGenerator.new()
	get_tree().create_timer(frequency*rng.randf()).timeout.connect(func():
		update_moodlet()
		timer.start()
	)
	pass
	
func update_moodlet() -> void:
	visible = true
	# Long if/else reduces my social credit score
	if animal and animal.state == Animal.State.SCARED:
		texture = preload("res://assets/ui/moodlet_scared.png")
	elif desire and desire.current_desire == Desire.DesireType.GREEN_PEN:
		texture = preload("res://assets/ui/moodlet_hungry.png")
	elif desire and desire.current_desire == Desire.DesireType.RED_PEN:
		texture = preload("res://assets/ui/moodlet_burning.png")
	elif desire and desire.current_desire == Desire.DesireType.BLUE_PEN:
		texture = preload("res://assets/ui/moodlet_thirsty.png")
	elif desire and desire.current_desire == Desire.DesireType.YELLOW_PEN:
		texture = preload("res://assets/ui/moodlet_shock.png")
	else:
		texture = preload("res://assets/ui/moodlet_wander.png")
	
	get_tree().create_timer(duration).timeout.connect(func():
		visible = false
	)

func _on_timer_timeout() -> void:
	update_moodlet()
