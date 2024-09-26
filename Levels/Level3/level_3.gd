extends Node2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready():
	RenderingServer.set_default_clear_color(Color("120f0b"))
	audio_stream_player.play()
