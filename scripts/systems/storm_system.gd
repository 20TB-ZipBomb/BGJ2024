extends Node
class_name StormSystem

@export_category("Storm Data")
@export var storm_duration: float = 10.0
@export var calm_duration: float = 10.0
@export_category("Tornado Data")
## The scene used for the tornado.
@export var tornado_scene: PackedScene = null

@onready var tornado_delay_timer: Timer = $Timers/TornadoDelayTimer


func _ready() -> void:
	# Begin the system in the calm state
	start_calm_period()


## Signal fired whenever we need to spawn a new tornado.
func _on_tornado_delay_timer_timeout() -> void:
	spawn_tornado()
	

# @TODO: Look up a number of tornadoes to spawn for this wave
## Spawns a tornado.
func spawn_tornado() -> void:
	add_child(tornado_scene.instantiate())


## Begins the calm period - begins the storm again after a fixed duration of time.
func start_calm_period() -> void:
	Log.debug("Started the calm period, it will last %d seconds" % calm_duration)
	
	await get_tree().create_timer(calm_duration).timeout
	start_next_wave()
	start_storm_period()


## Begins the storm - starts a timer that spawns tornadoes in a fixed interval.
## Once the storm period is over, the tornado spawner is stopped, and the calm period starts.
func start_storm_period() -> void:
	Log.debug("Started the storm period, it will last %d seconds" % storm_duration)
	tornado_delay_timer.start()
	
	await get_tree().create_timer(storm_duration).timeout
	tornado_delay_timer.stop()
	start_calm_period()


## Starts the next wave, increments the global wave counter.
func start_next_wave() -> void:
	Globals.current_storm_wave_number += 1
	Log.debug("Starting wave %s" % Globals.current_storm_wave_number)
