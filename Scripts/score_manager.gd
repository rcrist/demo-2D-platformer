extends Node

signal score_changed(new_value)

var player_score : int

func _ready():
	player_score = 0
		
func increase_score(score_amount : int):
	player_score += score_amount
	score_changed.emit(player_score)
