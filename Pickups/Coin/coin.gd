extends Area2D

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _on_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("Player"):
		audio_stream_player_2d.play()
		await get_tree().create_timer(0.3).timeout
		
		ScoreManager.increase_score(1)
		queue_free()
