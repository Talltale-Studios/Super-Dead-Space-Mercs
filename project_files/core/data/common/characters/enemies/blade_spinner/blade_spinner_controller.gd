extends BladeSpinner


## The character's movement speed.
@export var speed: float = 40
## The character's initial movement direction.
@export_enum("Right", "Left", "Up", "Down") var initial_dir = 0
## Which direction the character should rotate.
@export_enum("Clockwise", "Anti-clockwise") var rotation_dir = 0
## How many degrees the character should rotate in the chosen direction.
@export var rotation_deg: int = 90


@onready var wall_detector: RayCast2D = $WallDetector


var wall_detection_distance : float


func _ready() -> void:
	wall_detection_distance = wall_detector.target_position.x


func _physics_process(_delta: float) -> void:
	move_and_slide()
