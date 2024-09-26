extends Node2D

@export var next_scene : String = "Level3"

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if InventoryManager.check_item_in_inventory("Key"):
			MessageManager.display_message("Elvis has left the building")
			audio_stream_player_2d.play()
			await audio_stream_player_2d.finished
			
			var player = body as CharacterBody2D
			player.queue_free()
			
			await get_tree().create_timer(3.0).timeout
			SceneManager.transition_to_scene(next_scene)
		else:
			MessageManager.display_message("You need a key to open the door")
