extends CharacterBody2D

var enemy_death_effect = preload("res://Enemies/Enemy Death Effect/enemy_death_effect.tscn")

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var patrol_points : Node
@export var wait_time : int = 3
@export var damage_amount : int = 20

const GRAVITY : int = 2000
const WALK_SPEED : int = 1500

enum State { Idle, Walk }
var current_state : State
var direction: Vector2 = Vector2.LEFT

# Patrol area variables
var number_of_points : int
var point_positions : Array[Vector2]
var current_point : Vector2
var current_point_position : int
var can_walk : bool = false

# Enemy health variables
var health : int = 100

func _ready():
	if patrol_points != null:
		number_of_points = patrol_points.get_children().size()
		for point in patrol_points.get_children():
			point_positions.append(point.global_position)
		current_point = point_positions[current_point_position]
	else:
		print("No patrol points")
		
	timer.wait_time = wait_time
	
	current_state = State.Idle
	
func _physics_process(delta: float) -> void:
	enemy_falling(delta)
	enemy_idle(delta)
	enemy_walk(delta)
	
	move_and_slide()
	
	enemy_animations()
	
func enemy_falling(delta):
	if !is_on_floor():
		velocity.y += GRAVITY * delta
		
func enemy_idle(delta: float):
	if !can_walk:
		velocity.x = move_toward(velocity.x, 0, WALK_SPEED * delta)
		current_state = State.Idle
	
func enemy_walk(delta: float):
	if !can_walk:
		return
		
	if abs(position.x -current_point.x) > 0.5:
		velocity.x = direction.x * WALK_SPEED * delta
		current_state = State.Walk
	else:
		current_point_position += 1
		
		if current_point_position >= number_of_points:
			current_point_position = 0
			
		current_point = point_positions[current_point_position]
		
		if current_point.x > position.x:
			direction = Vector2.RIGHT
		else:
			direction = Vector2.LEFT
	
		can_walk = false
		timer.start()

	animated_sprite_2d.flip_h = direction.x < 0

func enemy_death():
	var enemy_death_effect_instance = enemy_death_effect.instantiate() as Node2D
	enemy_death_effect_instance.global_position = global_position
	get_parent().add_child(enemy_death_effect_instance)
	queue_free()
	
func decrease_health(player_damage_amount : int):
	health -= player_damage_amount
	print("enemy health: ", health)
	
	if health <= 0:
		audio_stream_player_2d.play()
		await audio_stream_player_2d.finished
		enemy_death()
	
func enemy_animations():
	if current_state == State.Idle and !can_walk:
		animated_sprite_2d.play("idle")
	elif current_state == State.Walk && can_walk:
		animated_sprite_2d.play("walk")

func _on_timer_timeout() -> void:
	can_walk = true
	
func _on_hurtbox_area_entered(area: Area2D) -> void:
	print("Spider hurtbox")
	if area.name == "Arrow":
		decrease_health(area.damage_amount)
		area.queue_free()
