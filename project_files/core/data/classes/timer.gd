class_name CoolTimer
extends Node

signal started
signal stopped
signal paused
signal timeout
signal restarted

enum ProcessCallbacks {
	IDLE,
	PHYSICS
}

@export var process_callback : ProcessCallbacks = ProcessCallbacks.IDLE


@export_custom(PROPERTY_HINT_RANGE, "0.001, 4096.0, 0.001,or_greater, exp, suffix:s") var wait_time: float = 1.0
@export var oneshot: bool
@export var autostart: bool
var time_left: float
var start_time: float
var ratio: float


var running: bool = false


func _init() -> void:
	set_physics_process(false)
	set_process(false)
	match process_callback:
		ProcessCallbacks.IDLE:
			set_process(true)
		ProcessCallbacks.PHYSICS:
			set_physics_process(true)


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass
