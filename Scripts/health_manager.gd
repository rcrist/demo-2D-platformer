extends Node

signal health_changed(new_value)

var player_health : int

func _ready():
	player_health = 100

func increase_health(health_amount : int):
	player_health += health_amount
	print("Player health: ", player_health)
	health_changed.emit(player_health)

func decrease_health(damage_amount : int):
	player_health -= damage_amount
	print("Player health: ", player_health)
	health_changed.emit(player_health)
