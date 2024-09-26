extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		InventoryManager.add_inventory_item(self)
		queue_free()
