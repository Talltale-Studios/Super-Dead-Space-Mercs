extends GamePlayerLegState


func update(_delta: float) -> void:
	if active:
		# Flip Sprite
		if _get_x_input() > 0:
			actor.legs_sprite.flip_h = false
		elif _get_x_input() < 0:
			actor.legs_sprite.flip_h = true

		# State animation
			if actor.alpha_coyote_timer.is_stopped() and actor.beta_coyote_timer.is_stopped():
				actor.legs_statemachine.travel("fall")


func state_handler(_delta: float) -> void:
	# Jumping and state switching
	if actor.can_jump:
		if actor.is_on_floor():
			actor.movement_component.had_jump_peak_float_time = false
			actor.had_alpha_coyote_time = false
			actor.has_jumped = false
			actor.jumps_made = 0
			# Transition to the 'jump' state if a jump is buffered and if enabled
			if actor.is_jump_buffered:
				actor.is_jump_buffered = false
				if GameSettings.is_jump_buffer_enabled:
					transition_to("jump")
					return
			# Else, transition to the 'stand' state
			else:
				transition_to("stand")
				return
		else:
			if not is_zero_approx(_get_x_input()):
				actor.legs_statemachine.travel("run")
			else:
				actor.legs_statemachine.travel("stand")
			if Input.is_action_just_pressed("jump"):
				# Coyote Jumping
				if actor.jumps_made < actor.max_jumps and GameSettings.is_alpha_coyote_jump_enabled:
					actor.has_jumped = false
					transition_to("jump")
					return
				# Jump Buffering
				if GameSettings.is_jump_buffer_enabled:
					if actor.jumps_made >= actor.max_jumps:
						actor.jump_buffer_timer.start()
						actor.is_jump_buffered = true
	else:
		if actor.is_on_floor():
			transition_to("stand")
			return
	activate_state()


func update_physics(delta: float) -> void:
	if active:
		# Movement
		actor.snap_vector = Vector2.ZERO
		#actor.velocity.x = lerp(actor.velocity.x, actor.speed * _get_x_input(), actor.acceleration)
		actor.velocity.x = move_toward(actor.velocity.x, actor.speed * _get_x_input(), actor.acceleration * delta)

		# Gravity
		_apply_gravity(delta)
