extends CharacterBody2D

@export var wander_radius: float = 500
@export var max_idle_time: int = 5
@export var navigation_agent: NavigationAgent2D
@export var nav_timer: Timer


enum STATE {
	LEASHED,
	IDLE,
	WANDER,
}

var movement_speed: float = 100.0
var movement_target_position: Vector2
var state: STATE = STATE.IDLE


func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0

	# Make sure to not await during _ready.
	call_deferred("actor_setup")

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	nav_timer.start()

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func _physics_process(_delta):
	if navigation_agent.is_navigation_finished():
		return

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()


func wander() -> void:
	if state == STATE.LEASHED:
		nav_timer.start()
		return
		
	state = STATE.WANDER
	print("wander")
	nav_timer.wait_time = 1.0
	var rand_x: float = randf_range(-wander_radius, wander_radius)
	var rand_y: float = randf_range(-wander_radius, wander_radius)
	var random_pos: Vector2 = Vector2(global_position.x + rand_x, global_position.y + rand_y)
	set_movement_target(random_pos)
	nav_timer.start()


func idle() -> void:
	if state == STATE.LEASHED:
		nav_timer.start()
		return
	
	state = STATE.IDLE
	nav_timer.wait_time = randi_range(1, max_idle_time)
	nav_timer.start()


func _on_nav_timer_timeout() -> void:
	if state == STATE.LEASHED:
		nav_timer.start()
		return
		
	var next_state: STATE = randi_range(1, STATE.size()) as STATE
	
	match next_state:
		STATE.IDLE:
			idle()
		STATE.WANDER:
			wander()
