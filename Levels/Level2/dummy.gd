extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

enum State { Idle, Hit }
var current_state : State

func _ready():
	current_state = State.Idle
	
func _physics_process(delta: float) -> void:
	enemy_idle(delta)	
	move_and_slide()
	enemy_animations()
	
func enemy_idle(_delta: float):
	current_state = State.Idle
	
func enemy_animations():
	if current_state == State.Idle:
		animated_sprite_2d.play("idle")
	elif current_state == State.Hit:
		animated_sprite_2d.play("hit")

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "Arrow":
		current_state = State.Hit
		area.queue_free()
		
		animated_sprite_2d.play("hit")
		audio_stream_player_2d.play()
		await audio_stream_player_2d.finished
		
		ScoreManager.increase_score(1)
