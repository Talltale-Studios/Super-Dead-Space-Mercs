extends BladeSpinner


@export var speed: float = 50
@export var wall_detection_distance : float = 9
@onready var wall_detector: RayCast2D = $WallDetector


func _physics_process(_delta: float) -> void:
	move_and_slide()
