extends Area2D

var key = preload("res://Pickups/Key/key.tscn")
var coin = preload("res://Pickups/Coin/coin.tscn")

@export var spawn_point_key : Marker2D
@export var spawn_point_coin : Marker2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var opened = false

func _ready():
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and !opened:
		animated_sprite_2d.play("open")
		
		# Play SFX
		audio_stream_player_2d.play()
		await  audio_stream_player_2d.finished
		
		# Spawn a key
		var key_instance = key.instantiate()
		key_instance.global_position = spawn_point_key.global_position
		get_parent().add_child(key_instance)
		
		# Spawn a coin
		var coin_instance = coin.instantiate()
		coin_instance.global_position = spawn_point_coin.global_position
		get_parent().add_child(coin_instance)
		
		opened = true
