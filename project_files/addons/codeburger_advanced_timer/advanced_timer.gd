@icon("res://addons/codeburger_advanced_timer/advanced_timer.svg")
class_name AdvancedTimer
extends Timer
## An advanced timer node that is built on top of the built-in [Timer] node. It
## comes with many new features in addition to the features inherited from the
## Timer node, including a new signal, new helper variables, new quality-of-life
## features for the functionalities inherited from the [Timer] node, and randomization
## functionality for [member Timer.wait_time].
# TO-DO LIST:
# * Setup clamp_wait_time.
#	EDIT: I think I got it working!
#
# * Setup the new timer_started() signal so it emits once when the timer starts (we can
#	check if time_left is greater than 0 to see if the timer is active).
#	EDIT: I think I got it working! It is probably more performance-intensive than
#		what we could make by making the plugin a GD Extension, but it does seem
#		to work.
#
# * Setup the rest of the randomization stuff.
#
# NOTES & IDEAS:
# * The built-in Timer already uses delta time, and through process_callback you
#	can already switch between using Process and Physics_Process for updating
#	the timer's time_left variable. As such, I can't think of any other custom
#	processing method that we can implement that isn't already possible through
#	the built-in Timer's. IMO we should just advise that process_callback should
#	be set to Physics if the user wants to set wait_time to a value lower than 0.5.
#	EDIT: Maybe there is a better way to process callbacks! The FrameTimer addon
#		by Nukiloco (https://github.com/Nukiloco/frame_timer) uses the operating
#		system's tickrate to calculate how much time is lost between frames and
#		uses that to adjust the timer's time_left variable to a more accurate
#		value! Theoretically, at least... if I understood it right.
#		I'm not sure how that compares to Process and Physics_Process though...
#		The addon also has a "ratio" variable, which we could also assimilate
#		into our addon as an additional QoL feature.
#		One thing that should be noted though is that the addon is for Godot
#		version 3.5, so we might have to make some adjustments to the code (for
#		example, the stuff that the other addon uses for the new processing method
#		has since then been moved over to the Time class, but the addon still
#		assumes that the stuff is in the OS class as it used to be back then).

# * Maybe we could add a "counter" mode to our timer that counts up instead of
#	down. Perhaps this new mode could even run at the same time as the usual
#	cowntdown, and it would have separate variables and signals more fitting
#	to its purpose. Examples:
#		* CountUpTimer by DeeJeez: https://godotengine.org/asset-library/asset/4333
#		* CounterTimer Node by BigDC: https://godotengine.org/asset-library/asset/1333

# * Note: When the timer is stopped, time_left is 0.0. When the timer is_paused(),
#	time_left remains what it was before (if it was at 0.05 when it got paused,
#	it will remain at 0.05 until unpaused, unless the time_left is changed manually).


#region Custom Signals

## Emitted when the timer is started.
signal timer_started

#endregion


#region Exported Public Properties

## If [code]true[/code], the timer's [member Timer.wait_time] will be clamped to a minimum value greater than [code]0[/code], as determined by [member clamp_min_threshold].
@export var clamp_wait_time: bool = true
## Specifies the minimum value that [member Timer.wait_time] will be clamped to if [member clamp_wait_time] is [code]true[/code].[br][br]
## [b]Note:[/b] If this variable has a value lower than [code]0.05[/code], it is recommended to set [member Timer.process_callback] to [code]Idle[/code] to avoid inconsistencies caused by the fluctuating framerate. See [member Timer.wait_time].
@export_custom(PROPERTY_HINT_RANGE, "0.001, 4096.0, 0.001,or_greater, exp, suffix:s") var clamp_min_threshold: float = 0.05
## Specifies the maximum value that [member Timer.wait_time] will be clamped to if [member clamp_wait_time] is [code]true[/code].[br][br]
@export_custom(PROPERTY_HINT_RANGE, "0.001, 4096.0, 0.001, or_greater, exp, suffix:s") var clamp_max_threshold: float = 4096.0
## If [code]true[/code], the timer will [method Node.queue_free] after reaching the end.
@export var self_destruct: bool = false

@export_category("Randomization")
## If [code]true[/code], the timer's [member Timer.wait_time] will be randomized.[br][br]
## [b]Note:[/b] The randomization will override [member Timer.wait_time] during runtime.
@export var enable_randomization: bool = false
## If [code]true[/code], the timer's [member Timer.wait_time] will be randomized when readying the timer.
@export var is_initially_randomized: bool = true
## If [code]true[/code], the seed for the timer's [RandomNumberGenerator] will [method RandomNumberGenerator.randomize] once again after every [member seed_rand_freq] times the timer has started. The randomization of the seed takes place on [signal timer_started].
@export var randomize_seed_on_start: bool = false
## If [code]true[/code], the seed for the timer's [RandomNumberGenerator] will [method RandomNumberGenerator.randomize] once again after every [member seed_rand_freq] times the timer has timed out. The randomization of the seed takes place on [signal Timer.timeout].
@export var randomize_seed_on_timeout: bool = false
## Specifies how many times the timer needs to be started or timed out before the seed of the timer's [RandomNumberGenerator] will [method RandomNumberGenerator.randomize], if [member randomize_seed_on_startup] or [member randomize_seed_on_timeout] are [code]true[/code].[br][br]
## Note: A value of [code]1[/code] will cause cause the seed to be randomized every time.
@export_custom(PROPERTY_HINT_RANGE, "1, 2, or_greater") var seed_rand_frequency: int = 1
## If [code]true[/code], the timer's [RandomNumberGenerator] will use a custom seed, determined by the [member custom_seed] property.
@export var use_custom_seed: bool = false
## The seed to be used if [member use_custom_seed] is set to [code]true[/code].
@export var custom_seed: int = 0
## Specifies which randomization method should be used if [member randomize_wait_time] is [code]true[/code].[br][br]
## If set to [code]Simple[/code], the randomization will use a seed that is randomized once during the setup of the timer. The [method RandomNumberGenerator.randf_range] function will be used, as well as the [member simple_rng_min] and [member simple_rng_max] variables.[br][br]
## If set to [code]Gaussian[/code], the randomization will use the [method RandomNumberGenerator.randfn] function, as well as the [member guassian_mean] and [member gaussian_deviation] variables.[br][br]
## If set to [code]Weighted[/code], the randomization will select a random number in a weighted array, wherein each number has a pre-determined probability weight. The [method RandomNumberGenerator.rand_weighted] method will be used, as well as the [member rng_weighted_array] variable.
@export_enum("Simple", "Gaussian", "Weighted") var rng_method = 0
## The minimum [member Timer.wait_time] to be used if [member rng_method] is set to [code]Simple[/code].[br][br]
## [b]Note:[/b] If this variable has a value lower than [code]0.05[/code], it is recommended to set [member Timer.process_callback] to [code]Idle[/code] to avoid inconsistencies caused by the fluctuating framerate. See [member Timer.wait_time].
@export_range(0.001, 4096.0, 0.001, "or_greater", "exp", "suffix:s") var simple_rng_min: float = 1.0
## The maximum [member Timer.wait_time] to be used if [member rng_method] is set to [code]Simple[/code].
@export_range(0.05, 4096.0, 0.001, "or_greater", "exp", "suffix:s") var simple_rng_max: float = 2.0
## The mean (average) of the Gaussian distribution.
@export_range(0.001, 4096.0, 0.001, "or_greater", "exp", "suffix:s") var gaussian_mean: float = 1.0
## The standard deviation of the Gaussian distribution, which controls the spread of the numbers around the mean.
@export_range(0.001, 4096.0, 0.001, "or_greater", "exp", "suffix:s") var gaussian_deviation: float = 0.5
## The array that will be used, if [member rng_method] is set to [code]Weighted[/code], to determine a list of numbers to use for randomizing the timer's [member Timer.wait_time], as well as their probability weights.
@export var rng_weighted_array: Array[PackedFloat32Array] = []
## If [code]true[/code], the [member rng_weighted_array] will cycle through all the indexes before any index can be repeated. This is also known as a [url=https://docs.godotengine.org/en/latest/tutorials/math/random_number_generation.html#better-randomness-using-shuffle-bags]shuffle bag pattern[/url].
@export var rng_cycle_through_array: bool = false

#endregion


#region Public Properties

## The [RandomNumberGenerator] that is used for the timer's randomization functionality.
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

#endregion


#region Private Properties

var _started_timer: bool = false

#endregion


#region Private Functions

func _ready() -> void:
	timer_started.connect(_on_timer_started)
	timeout.connect(_on_timeout)

	if use_custom_seed:
		rng.set_seed(custom_seed)
	else:
		rng.randomize()

	if enable_randomization:
		if is_initially_randomized:
			if rng_method == 0:
				wait_time = rng.randf_range(simple_rng_min, simple_rng_max)
			if rng_method == 1:
				wait_time = rng.randfn(gaussian_mean, gaussian_deviation)
			if rng_method == 2:
				pass

func _physics_process(delta: float) -> void:
	print("[", Time.get_time_string_from_system(), "] time_left = ", time_left)
	
	if clamp_wait_time:
		clampf(wait_time, clamp_min_threshold, clamp_max_threshold)
	
	if time_left > 0 and not _started_timer:
		print("[", Time.get_time_string_from_system(), "] time_left > 0")
		emit_signal("timer_started")
		_started_timer = true

#region Signal Functions
func _on_timer_started() -> void:
	print("[", Time.get_time_string_from_system(), "] Signal Emitted: timer_started()")


func _on_timeout() -> void:
	print("[", Time.get_time_string_from_system(), "] Signal Emitted: timeout()")
	_started_timer = false
	
	if self_destruct:
		queue_free()

#endregion
#endregion
