## Virtual base class for all states.
class_name GameState
extends Node


var active: bool = false


## Reference to the state machine, to call its [code]transition_to()[/code]
## method directly.
## It adds a dependency between the state and the state machine objects.
## The state machine will set it.
var state_machine: GameStateMachine = null


## Virtual function. Called by the state machine upon changing the active state.
func enter_state() -> void:
	pass


func activate_state() -> void:
	active = true


## Virtual function. Called by the state machine before changing the active state.
func exit_state() -> void:
	active = false


func transition_to(state_name: String) -> void:
	exit_state()
	state_machine.change_state(state_name)


## Virtual function. Receives events from the [code]_process()[/code] callback. Used for making visual changes.
func update(_delta: float) -> void:
	pass


## Virtual function. Receives events from the [code]_process()[/code] callback. Used for computations.
func compute(_delta: float) -> void:
	pass


func state_handler(_delta: float) -> void:
	pass


## Virtual function. Receives events from the [code]_physics_process()[/code] callback.
func update_physics(_delta: float) -> void:
	pass


## Virtual function. Receives events from the [code]_input()[/code] callback.
func compute_input(_event: InputEvent) -> void:
	pass


## Virtual function. Receives events from the [code]_unhandled_input()[/code] callback.
func compute_unhandled_input(_event: InputEvent) -> void:
	pass


## Virtual function. Receives events from the [code]_unhandled_key_input()[/code] callback.
func compute_unhandled_key_input(_event: InputEvent) -> void:
	pass


## Virtual function. Receives events from the [code]_notification()[/code] callback.
func notification_custom(_what: int, _flag: bool = false) -> void:
	pass
