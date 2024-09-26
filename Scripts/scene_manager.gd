extends Node

var scenes : Dictionary = { "Level1": "res://Levels/Level1/level_1.tscn",
							"Level2": "res://Levels/Level2/level_2.tscn",
							"Level3": "res://Levels/Level3/level_3.tscn",
							"Level4": "res://Levels/Level4/level_4.tscn"}
							
func transition_to_scene(level : String):
	var scene_path : String = scenes.get(level)
	
	if scene_path != null:
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file(scene_path)
