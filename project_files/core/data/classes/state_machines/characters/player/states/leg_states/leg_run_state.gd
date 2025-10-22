extends GamePlayerLegState


func update(_delta: float) -> void:
	if active:
		# Flip Sprite
		if _get_x_input() > 0:
			actor.legs_sprite.flip_h = false
		elif _get_x_input() < 0:
			actor.legs_sprite.flip_h = true

		# State animation
		actor.legs_statemachine.travel("run")


func state_handler(_delta: float) -> void:
	# State switching
	if is_zero_approx(_get_x_input()):
		transition_to("stand")
		return
	if Input.is_action_just_pressed("jump"):
		transition_to("jump")
		return
	if not actor.is_on_floor():
		_apply_coyote_time(0)
		transition_to("fall")
		return
	activate_state()


func update_physics(delta: float) -> void:
	if active:
		# Movement
		actor.snap_vector = Vector2.DOWN
		#actor.velocity.x = lerp(actor.velocity.x, actor.speed * _get_x_input(), actor.acceleration)
		actor.velocity.x = move_toward(actor.velocity.x, actor.speed * _get_x_input(), actor.acceleration * delta)

		# Gravity
		_apply_gravity(delta)
