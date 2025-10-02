## Virtual base class for all state machines
class_name GameStateMachine
extends Node


@export var debug: bool = false

@export var actor : PhysicsBody2D
## Path to the initial active state. It is exported so that the
## [code]initial_state[/code] can be picked in the Inspector.
@export_node_path("GameState") var initial_state: NodePath


var state_history: Array[String]
var max_state_history_size: int = 5


## The current active state.
## At the start of the game, we get the [code]initial_state[/code].
var current_state: GameState


func _ready() -> void:
	# Set the initial active state to the [code]initial_state[/code]
	current_state = get_node(initial_state)
	_enter_state()


## Change to a new state
func change_state(new_state: String) -> void:
	state_history.append(current_state.name)

	if state_history.size() > max_state_history_size:
		state_history.pop_front()

	current_state = get_node(new_state.to_pascal_case())
	_enter_state()


## Travel to the previous state
func back() -> void:
	if state_history.size() > 0:
		current_state = get_node(state_history.pop_back())
		_enter_state()


func _enter_state() -> void:
	if debug:
		print("Entering State: ", current_state.name)
	# Give the new state a reference to this statemachine script
	current_state.state_machine = self
	current_state.enter_state()


# Route game loop function calls to
# current state handler method if it exists
func _process(delta: float) -> void:
	current_state.update(delta)


func _physics_process(delta: float) -> void:
	current_state.state_handler(delta)
	current_state.update_physics(delta)


func _input(event: InputEvent) -> void:
	current_state.compute_input(event)


func _unhandled_input(event: InputEvent) -> void:
	current_state.compute_unhandled_input(event)


func _unhandled_key_input(event: InputEvent) -> void:
	current_state.compute_unhandled_key_input(event)


func _notification(what: int) -> void:
	if is_instance_valid(current_state):
		current_state.notification_custom(what)
