extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const GRAVITY : int = 2000

func _physics_process(delta):
	player_falling(delta)
	animated_sprite_2d.play("idle")
	
	move_and_slide()
	
func player_falling(delta):
	if !is_on_floor():
		velocity.y += GRAVITY * delta

func _on_area_2d_body_entered(body: Area2D):
	if body.is_in_group("Player"):
		MessageManager.display_message("Find the key to the cave door")
