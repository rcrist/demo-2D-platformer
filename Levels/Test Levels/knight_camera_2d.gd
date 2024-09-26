extends Camera2D

@export var knight : CharacterBody2D

func _physics_process(_delta: float) -> void:
	if knight != null:
		global_position = knight.global_position
