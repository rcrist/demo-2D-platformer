extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		Global.can_climb = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		Global.can_climb = false
