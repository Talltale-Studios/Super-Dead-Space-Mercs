@icon("res://addons/codeburger_advanced_timer/advanced_timer.svg")
class_name AdvancedTimer
extends Timer
## An advanced timer node with extra functionality, including a new
## [signal timer_started] signal, new quality of life features for the built-in]
## timer functionality, and entirely new randomization features for
## [member Timer.wait_time].[br][br]
## Note: The new randomization features override the built-in
## [member Timer.wait_time] if enabled.
# To-do list:
# * Setup clamp_wait_time.
# * Setup the new active() signal so it emits once when the timer starts (we can
#	check if time_left is greater than 0 to see if the timer is active).
# * Setup the rest of the randomization stuff.
# Ideas:
# * Add an option to use a custom timer processing method. Timers can only process once
#	per physics or process frame (depending on the process_callback). An unstable
#	framerate may cause the timer to end inconsistently, which is especially
#	noticeable if the wait time is lower than roughly 0.05 seconds. For very
#	short timers, it is recommended to write your own code instead of using a
#	Timer node. Or maybe this custom processing method is automatically activated
#	if the timer's wait_time is lower than 0.1 seconds?


#region Custom Signals

## Emitted when the timer is started.
signal timer_started

#endregion


#region Exported Public Properties

## If [code]true[/code], the timer's [member Timer.wait_time] will be clamped to a minimum of [code]0.001[/code].
@export var clamp_min_wait_time: bool = true
## If [code]true[/code], the timer will [method Node.queue_free] after reaching the end.
@export var self_destruct: bool = false
@export_category("Randomization")
## If [code]true[/code], the timer's [member Timer.wait_time] will be randomized.
@export var randomization_enabled: bool = 0
## If [code]true[/code], the seed for the timer's [RandomNumberGenerator] will [method RandomNumberGenerator.randomize] once again after every [member seed_rand_freq] times the timer has started. The randomization of the seed takes place on [signal timer_started].
@export var randomize_seed_on_start: bool = 0
## If [code]true[/code], the seed for the timer's [RandomNumberGenerator] will [method RandomNumberGenerator.randomize] once again after every [member seed_rand_freq] times the timer has timed out. The randomization of the seed takes place on [signal Timer.timeout].
@export var randomize_seed_on_timeout: bool = 0
## Specifies how many times the timer needs to be started or timed out before the seed of the timer's [RandomNumberGenerator] will [method RandomNumberGenerator.randomize] once again if [member randomize_seed_on_startup] and/or [member randomize_seed_on_timeout] is [code]true[/code].[br][br]
## Note: A value of [code]1[/code] will cause it to trigger every time.
@export_custom(PROPERTY_HINT_RANGE, "1, 2, or_greater") var seed_rand_freq: int = 1
## If [code]true[/code], the timer's [RandomNumberGenerator] will use a custom seed, determined by the [member custom_seed] property.
@export var use_custom_seed: bool = false
## The seed to be used if [member use_custom_seed] is set to [code]true[/code].
@export var custom_seed: int = 0
## If [code]true[/code], the timer's [member Timer.wait_time] will be randomized on the first start, including [member Timer.auto_start], otherwise it will only start randomizing during the first repitition and onwards.
@export var is_initially_randomized: bool = 1
## Specifies which randomization method should be used if [member randomize_wait_time] is [code]true[/code].[br][br]
## If set to [code]Simple[/code], the randomization will use a seed that is randomized once during the setup of the timer. The [method RandomNumberGenerator.randf_range] method will be used.[br][br]
## If set to [code]Gaussian[/code], the randomization will use the [method RandomNumberGenerator.randfn] method.[br][br]
## If set to [code]Weighted[/code], the randomization will select a random number in [member weighted_array], wherein each number has a pre-determined probability weight. The [method RandomNumberGenerator.rand_weighted] method will be used.
@export_enum("Simple", "Gaussian", "Weighted") var rng_method = 0
## The minimum [member Timer.wait_time] to be used if [member rng_method] is set to [code]Simple[/code].
@export_range(0.05, 4096.0, 0.001, "or_greater", "exp", "suffix:s") var min_wait_time: float = 0.001
## The maximum [member Timer.wait_time] to be used if [member rng_method] is set to [code]Simple[/code].
@export_range(0.05, 4096.0, 0.001, "or_greater", "exp", "suffix:s") var max_wait_time: float = 1.0
## The mean (average) of the Gaussian distribution.
@export_range(0.001, 4096.0, 0.001, "or_greater", "exp", "suffix:s") var gaussian_mean: float = 1.0
## The standard deviation of the Gaussian distribution, which controls the spread of the numbers around the mean.
@export_range(0.001, 4096.0, 0.001, "or_greater", "exp", "suffix:s") var gaussian_deviation: float = 0.1
## The array used if [member rng_method] is set to [code]Weighted[/code] to determine a list of numbers to use for randomizing the timer's [member Timer.wait_time], as well as their probability weights.
@export var weighted_array: Array[PackedFloat32Array] = []
## If [code]true[/code], the [member weighted_array] will cycle through all the indexes before any index can be repeated. This is also known as a shuffle bag pattern.
@export var cycle_through_array: bool = false

#endregion


#region Public Properties

## The [RandomNumberGenerator] that is used for the timer's randomization functionality.
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

#endregion


#region Built-in Functions

func start(time: float = -1) -> void:
	#if wait_time < 0.05:
		#wait_time = 0.05
	timer_started.emit()
	super(time)

#endregion


#region Private Functions

func _ready() -> void:
	timer_started.connect(_on_timer_started)
	timeout.connect(_on_timeout)

	if rng_method == 1:
		rng.set_seed(custom_seed)
	else:
		rng.randomize()

	if randomization_enabled:
		if is_initially_randomized:
			if rng_method == 0:
				wait_time = rng.randf_range(min_wait_time, max_wait_time)
			if rng_method == 1:
				pass


func _on_timer_started() -> void:
	print(true)


func _on_timeout() -> void:
	if self_destruct:
		queue_free()

#endregion
