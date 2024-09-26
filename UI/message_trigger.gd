extends Area2D

@export var message : String = "Put message here"

func _ready():
	pass
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		MessageManager.display_message(message)
