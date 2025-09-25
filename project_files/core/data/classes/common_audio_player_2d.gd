class_name CommonAudioPlayer2D
extends AudioStreamPlayer2D


@export var change_pitch : bool
@export_range(0.0, 1.0, 0.01) var pitch_difference: float


func play_effect(from_position: float = 0.0) -> void:
	if change_pitch:
		pitch_scale = 1.0 + randf_range(-pitch_difference, pitch_difference)
	play(from_position)
