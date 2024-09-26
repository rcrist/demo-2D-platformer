extends CanvasLayer

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready():
	audio_stream_player.play()

func _on_play_button_pressed() -> void:
	GameManager.start_game()
	queue_free()

func _on_exit_button_pressed() -> void:
	GameManager.exit_game()
