extends GameKinematicPlayer


#region Public Properties

var legs_statemachine: AnimationNodeStateMachinePlayback

#endregion


#region Private Functions

func _physics_process(_delta):
	legs_statemachine = legs_anim_tree["parameters/playback"]

	_aim()
	if Input.is_action_pressed("shoot"):
		var weaponflash_statemachine: AnimationNodeStateMachinePlayback = weaponflash_anim_tree["parameters/playback"]
		weaponflash_statemachine.travel("shoot")

	match environment:
		ENVIRONMENTS.SURFACE:
			_set_gravity_env("surface")
			_set_jump_vel_cut_env("surface")
			_set_velocity_clamp_env("surface")
			if is_on_floor():
				_set_accel_env("surface_grounded")
				_set_fric_env("surface_grounded")
			else:
				_set_accel_env("surface_airborne")
				_set_fric_env("surface_airborne")
		ENVIRONMENTS.UNDERWATER:
			_set_gravity_env("underwater")
			_set_jump_vel_cut_env("underwater")
			_set_velocity_clamp_env("underwater")
			if is_on_floor():
				_set_accel_env("underwater_grounded")
				_set_fric_env("underwater_grounded")
			else:
				_set_accel_env("underwater_airborne")
				_set_fric_env("underwater_airborne")
		ENVIRONMENTS.SPACE:
			_set_gravity_env("space")
			_set_jump_vel_cut_env("space")
			_set_velocity_clamp_env("space")
			if is_on_floor():
				_set_accel_env("space_grounded")
				_set_fric_env("space_grounded")
			else:
				_set_accel_env("space_airborne")
				_set_fric_env("space_airborne")

	move_and_slide()


func _input(event):
	if event.is_action_released("jump") and velocity.y < 0:
		velocity.y *= jump_release_velocity_cut


func _on_jump_buffer_timer_timeout() -> void:
	is_jump_buffered = false


func _on_jump_peak_float_timer_timeout() -> void:
	pass

#endregion
