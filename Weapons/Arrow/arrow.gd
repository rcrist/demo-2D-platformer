extends Area2D

@export var speed : float = 1750
var damage_amount = 10

func _physics_process(delta: float) -> void:
	position.x += speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	# When the arrow leaves the screen they get destroyed
	queue_free()
