extends GamePlayerLegState


func update(_delta: float) -> void:
	if active:
		# Flip Sprite
		if _get_x_input() > 0:
			actor.legs_sprite.flip_h = false
		elif _get_x_input() < 0:
			actor.legs_sprite.flip_h = true

		# State animation
		actor.legs_statemachine.travel("jump")


func state_handler(_delta: float) -> void:
	# State switching & jumping
	if actor.can_jump:
		if actor.is_on_floor() or not actor.prim_coyote_timer.is_stopped():
			if not actor.has_jumped:
					_jump()
					actor.has_jumped = true
			else:
				actor.has_jumped = false
				actor.jumps_made = 0
				transition_to("stand")
				return
		else:
			if not actor.has_jumped:
				if actor.jumps_made < actor.max_jumps:
					_jump()
					actor.has_jumped = true
			if actor.velocity.y > 0:
				transition_to("fall")
				return
			if Input.is_action_just_pressed("jump"):
					# Coyote Jumping
					if actor.jumps_made < actor.max_jumps and GameSettings.is_prim_coyote_jump_enabled:
						_jump()
	else:
		if actor.velocity.y > 0:
			transition_to("fall")
			return
		else:
			transition_to("stand")
			return
	activate_state()


func update_physics(delta: float) -> void:
	if active:
		# Movement
		actor.snap_vector = Vector2.ZERO
		actor.velocity.x = lerp(actor.velocity.x, actor.speed * _get_x_input(), actor.acceleration)

		# Gravity
		_apply_gravity(delta)
