extends GamePlayerLegState

func update(_delta: float) -> void:
	if active:
		# Flip Sprite
		if _get_x_input() > 0:
			actor.legs_sprite.flip_h = false
		elif _get_x_input() < 0:
			actor.legs_sprite.flip_h = true

		# State animation
		actor.legs_statemachine.travel("crouch")


func state_handler(_delta: float) -> void:
	# State switching
	if not is_zero_approx(_get_x_input()):
		transition_to("run")
		return
	if Input.is_action_just_released("down"):
		transition_to("stand")
		return
	if Input.is_action_just_pressed("jump"):
		transition_to("jump")
		return
	if not actor.is_on_floor():
		transition_to("fall")
		return
	activate_state()


func update_physics(delta: float) -> void:
	if active:
		# Movement
		actor.snap_vector = Vector2.DOWN
		#actor.velocity.x = lerp(actor.velocity.x, 0.0, actor.friction)
		actor.velocity.x = move_toward(actor.velocity.x, 0.0, actor.friction * delta)

		# Gravity
		_apply_gravity(delta)
