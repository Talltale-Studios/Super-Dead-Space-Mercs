class_name GamePlayerState
extends GameCharacterState


func _jump():
	actor.velocity.y = actor.jump_velocity
	actor.jumps_made += 1
	actor.alpha_coyote_timer.stop()


func _ledge_hop():
	actor.velocity.y = actor.jump_velocity


func _get_gravity() -> float:
	if actor.velocity.y < 0.0 or Input.is_action_pressed("jump"):
		return actor.jump_gravity
	else:
		return actor.fall_gravity


func _apply_coyote_time(type: int):
	# Apply alpha Coyote Time
	if type == 0:
		if GameSettings.is_alpha_coyote_time_enabled:
			if not actor.has_jumped:
				if not actor.had_alpha_coyote_time:
					if actor.alpha_coyote_timer.is_stopped():
						actor.alpha_coyote_timer.start()
						actor.velocity.y = 0
						actor.had_alpha_coyote_time = true
	# Apply beta Coyote Time
	if type == 1:
		if GameSettings.is_beta_coyote_time_enabled:
			if actor.beta_coyote_timer.is_stopped() and not actor.had_beta_coyote_time and not actor.has_jumped:
				actor.beta_coyote_timer.start()
				actor.velocity.y = 0
				actor.had_beta_coyote_time = true


func _apply_jump_peak_float_time():
	if GameSettings.is_jump_peak_float_time_enabled:
		actor.movement_component.had_jump_peak_float_time = true
		actor.jump_peak_float_timer.start()


func _apply_gravity(delta):
	if actor.jump_peak_float_timer.is_stopped():
		if actor.alpha_coyote_timer.is_stopped() and actor.beta_coyote_timer.is_stopped():
			actor.velocity.y += _get_gravity() * delta
		elif not actor.alpha_coyote_timer.is_stopped() and actor.beta_coyote_timer.is_stopped():
			actor.velocity.y += _get_gravity() * delta * actor.alpha_coyote_time_grav_mult
		elif actor.alpha_coyote_timer.is_stopped() and not actor.beta_coyote_timer.is_stopped():
			actor.velocity.y += _get_gravity() * delta * actor.beta_coyote_time_grav_mult
		else:
			# Uh... I don't know if this is what we want to do but at least he logic for it is here now...
			actor.velocity.y += _get_gravity() * delta * actor.alpha_coyote_time_grav_mult * actor.beta_coyote_time_grav_mult
	else:
		actor.velocity.y += _get_gravity() * delta * actor.jump_peak_float_time_grav_mult


func _get_x_input() -> float:
	return Input.get_action_strength("right") - Input.get_action_strength("left")


func _get_dir() -> Vector2:
	return Vector2(_get_x_input(), -1.0 if Input.is_action_just_pressed("jump") and state_machine.actor.has_jumped else 1.0)
