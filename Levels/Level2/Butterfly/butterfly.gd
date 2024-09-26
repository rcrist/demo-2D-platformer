extends Node2D

@onready var path_follow: PathFollow2D = $Path2D/PathFollow2D

@export var speed = 150

var follow = PathFollow2D.new()
	
func _physics_process(delta: float):
	path_follow.progress += speed * delta
