extends GameBladeSpinnerState


var direction : Vector2 = Vector2.RIGHT
var move_clockwise : bool = true


func ready() -> void:
	actor.wall_detector.target_position = actor.wall_detection_distance


func state_handler(_delta: float) -> void:
	activate_state()


func update_physics(_delta: float) -> void:
	if active:
		actor.wall_detector.force_raycast_update()
		if actor.wall_detector.is_colliding():
			if move_clockwise:
				direction = direction.rotated(deg_to_rad(actor.rotation_deg))
			else:
				direction = direction.rotated(deg_to_rad(-(actor.rotation_deg)))
			actor.wall_detector.target_position = direction * actor.wall_detection_distance
		else:
			actor.velocity = actor.speed * direction
