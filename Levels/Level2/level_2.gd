extends Node2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready():
	RenderingServer.set_default_clear_color(Color("013a45"))
	audio_stream_player.play()
