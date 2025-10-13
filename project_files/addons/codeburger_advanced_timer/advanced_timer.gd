@icon("res://addons/codeburger_advanced_timer/advanced_timer.svg")
class_name AdvancedTimer
extends Timer
## An advanced timer node with extra functionality.


#region Exported Properties

## If [code]true[/code], the timer will [method Node.queue_free] after reaching the end.
@export var self_destruct: bool = false
## If [code]true[/code], the timer's [member Timer.wait_time] will be randomized.
@export var randomize_wait_time: bool = 0
## If [code]true[/code], the timer's [member Timer.wait_time] will be randomized on the first start, including [member Timer.auto_start], otherwise it will only start randomizing during the first repitition and onwards.
@export var is_initially_randomized: bool = 1
## Specifies the type of randomness that should be used if [member randomize_wait_time] is [code]true[/code].[br][br]
## If set to [code]Basic[/code], the randomization will use a seed that is randomized once during the setup of the timer. This randomization method uses [method RandomNumberGenerator.randf_range].[br][br]
## If set to [code]Seeded[/code], the randomization will use a fixed seed that is pre-determined by [member rng_seed]. This randomization method uses [method RandomNumberGenerator.randf_range].[br][br]
## If set to [code]Gaussian[/code], the randomization will use [member RandomNumberGenerator.randfn].[br][br]
## If set to [code]True[/code], the randomness will use a seed that is randomized each time the timer starts, making it more resource-intensive but providing much less predictable randomization. This randomization method uses [method RandomNumberGenerator.randf_range].[br][br]
## If set to [code]Weighted[/code], the randomization will select a random number in [member rng_weighted_array], wherein each number has a pre-determined probability weight. This randomization method uses [method RandomNumberGenerator.rand_weighted].
@export_enum("Basic", "Seeded", "Gaussian", "True", "Weighted") var rng_method = 0
## The minimum [member Timer.wait_time] to be used if [member rng_method] is set to [code]Basic[/code], [code]Seeded[/code] or [code]True[/code].
@export_range(0.001, 4096.0, 0.001, "or_greater", "exp", "suffix:s") var rng_min_wait_time: float = 0.001
## The maximum [member Timer.wait_time] to be used if [member rng_method] is set to [code]Basic[/code], [code]Seeded[/code] or [code]True[/code].
@export_range(0.001, 4096.0, 0.001, "or_greater", "exp", "suffix:s") var rng_max_wait_time: float = 1.0
## The seed to be used if [member rng_method] is set to [code]Seeded[/code].
@export var rng_seed: int
## The array used if [member rng_method] is set to [code]Weighted[/code] to determine a list of numbers to use for randomizing the timer's [member Timer.wait_time], as well as their probability weights.
@export var rng_weighted_array: Array[PackedFloat32Array] = []
## If [code]true[/code], the [method rng_weighted_array] will cycle through all the indexes before any index can be repeated.
@export var cycle_through_array: bool = false

#endregion


#region Private Functions

func _ready() -> void:
	timeout.connect(_on_timeout)


func _on_timeout() -> void:
	if self_destruct:
		queue_free()

#endregion
