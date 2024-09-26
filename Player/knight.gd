extends CharacterBody2D

var player_death_effect = preload("res://Player/Player Death Effects/player_death_effect.tscn")

@onready var sword_animated_sprite: AnimatedSprite2D = $SwordAnimatedSprite
@onready var bow_animated_sprite: AnimatedSprite2D = $BowAnimatedSprite
@onready var no_weapon_animated_sprite: AnimatedSprite2D = $NoWeaponAnimatedSprite

@onready var arrow_placement = $ArrowPlacement
@onready var arrow_scene = preload("res://Weapons/Arrow/arrow.tscn")

@onready var player_death_sfx: AudioStreamPlayer2D = $PlayerDeathSFX
@onready var player_hit_sfx: AudioStreamPlayer2D = $PlayerHitSFX

const GRAVITY : int = 2000 
const WALK_SPEED : int = 600
const RUN_SPEED : int = 1000
const JUMP_SPEED : int = -1000

enum WeaponState {NoWeapon, Sword, Bow}
var current_weapon_state : WeaponState

enum State { Attack, Die, Hit, Idle, Jump, Run, Walk }
var current_state : State

var current_animated_sprite : AnimatedSprite2D

var damage_amount : int = 20
var release_pt_x : float  # X position of arrow_placment
var can_shoot : bool = true

func _ready():
	current_state = State.Idle
	release_pt_x = arrow_placement.position.x
	activate_no_weapon_sprite()
	#activate_bow_sprite()
	bow_animated_sprite.connect("animation_finished" , animation_finished)
	
func _physics_process(delta):
	player_falling(delta)
	player_idle(delta)
	player_walk(delta)
	player_run(delta)
	player_jump(delta)
	player_attack(delta)
	attack_frame()
	
	move_and_slide()
	
	player_animations()
	
func player_falling(delta):
	if !is_on_floor():
		velocity.y += GRAVITY * delta
		
func player_idle(_delta):
	if is_on_floor():
		current_state = State.Idle
		
func player_walk(_delta):
	var direction = Input.get_axis("left", "right")
	
	if direction:
		velocity.x = direction * WALK_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, WALK_SPEED)
		
	if direction != 0 and current_state != State.Jump:
		current_state = State.Walk
		current_animated_sprite.flip_h = false if direction > 0 else true
	elif direction == 0:
		current_state = State.Idle
		
func player_run(_delta):
	if !Input.is_key_pressed(KEY_SHIFT):
		return
		
	var direction = Input.get_axis("left", "right")
	
	if direction:
		velocity.x = direction * RUN_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, RUN_SPEED)
		
	if direction != 0 and current_state != State.Jump:
		current_state = State.Run
		current_animated_sprite.flip_h = false if direction > 0 else true
		
func player_jump(_delta):
	if Input.is_action_just_pressed("jump"):
		current_state = State.Jump
		velocity.y = JUMP_SPEED
		
func player_attack(_delta):
	if Input.is_action_just_pressed("shoot") and can_shoot and current_weapon_state == WeaponState.Bow:
		can_shoot = false
		current_animated_sprite.play("attack")
		await get_tree().create_timer(0.1).timeout
		
		var arrow = arrow_scene.instantiate() as Node2D
		var arrow_sprite = arrow.get_node("Sprite2D")
		var player_sprite = current_animated_sprite
		
		if player_sprite.flip_h:
			arrow_placement.position.x = -release_pt_x
		else:
			arrow_placement.position.x = release_pt_x
		
		arrow.global_position = arrow_placement.global_position
			
		if player_sprite.flip_h:
			arrow_sprite.flip_h = true
			arrow.speed = arrow.speed * -1
		else:
			arrow_sprite.flip_h = false
			arrow.speed = arrow.speed * 1
			
		get_parent().add_child(arrow)

		can_shoot = true
		current_animated_sprite.play("idle")
	elif Input.is_action_just_pressed("shoot") and can_shoot and current_weapon_state == WeaponState.Sword:
		current_state = State.Attack
		
func input_movement() -> float:
	var direction : float = Input.get_axis("left", "right")
	if direction == 0:
		direction = 1
	return direction
		
func attack_frame():
	if current_state != State.Attack or current_weapon_state != WeaponState.Sword:
		return
		
	var current_frame = sword_animated_sprite.get_frame()
	if current_frame == 3 or current_frame == 4:
		get_parent().get_node("Knight/SwordHitBox/SwordHitboxCollisionShape").disabled = true
	else:
		get_parent().get_node("Knight/SwordHitBox/SwordHitboxCollisionShape").disabled = false
		
func player_animations():
	if current_state == State.Idle:
		current_animated_sprite.play("idle")
	elif current_state == State.Walk:
		current_animated_sprite.play("walk")
	elif current_state == State.Jump:
		current_animated_sprite.play("jump")
	elif current_state == State.Run:
		current_animated_sprite.play("run")
	elif current_state == State.Die:
		current_animated_sprite.play("die")
	elif current_state == State.Hit:
		current_animated_sprite.play("hit")
	elif current_state == State.Attack and current_weapon_state != WeaponState.NoWeapon:
		current_animated_sprite.play("attack")
		
		# Wait for attack animation to finish
		while current_animated_sprite.is_playing() && current_animated_sprite.get_animation() == "Attack":
			pass
			
func animation_finished():
	current_state = State.Idle

func player_death():
	var player_death_effect_instance = player_death_effect.instantiate() as Node2D
	player_death_effect_instance.global_position = global_position
	get_parent().add_child(player_death_effect_instance)
	GameManager.game_over_died()
	queue_free()

func _on_hurtbox_body_entered(body) -> void:
	print("Knight hurtbox entered")
	if body.is_in_group("Enemy"):
		HealthManager.decrease_health(body.damage_amount)
		player_hit_sfx.play()
		current_state = State.Hit

	if HealthManager.player_health <= 0:
		player_death_sfx.play()
		await player_death_sfx.finished
		player_death()
		current_state = State.Die

func _on_sword_hitbox_body_entered(body: Node2D) -> void:
	print("Knight Sword Hitbox Entered")
	if body.is_in_group("Enemy"):
		print("Attacking enemy: ", damage_amount)
		body.decrease_health(damage_amount)

func _on_weapon_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Weapon"):
		body.decrease_health(damage_amount)

func _on_weapon_box_area_entered(area: Area2D) -> void:
	print("Weapon area entered: ", area)
	if area.is_in_group("Weapon"):
		print("Weapon Group found")
		if area.name == "SwordPickup":
			activate_sword_sprite()
		if area.name == "BowPickup":
			activate_bow_sprite()

func activate_no_weapon_sprite():
	current_weapon_state = WeaponState.NoWeapon
	current_animated_sprite = no_weapon_animated_sprite
	no_weapon_animated_sprite.visible = true
	sword_animated_sprite.visible = false
	bow_animated_sprite.visible = false
	debug_print_weapon_state()
	
func activate_sword_sprite():
	current_weapon_state = WeaponState.Sword
	current_animated_sprite = sword_animated_sprite
	no_weapon_animated_sprite.visible = false
	sword_animated_sprite.visible = true
	bow_animated_sprite.visible = false
	debug_print_weapon_state()
		
func activate_bow_sprite():
	current_weapon_state = WeaponState.Bow
	current_animated_sprite = bow_animated_sprite
	no_weapon_animated_sprite.visible = false
	sword_animated_sprite.visible = false
	bow_animated_sprite.visible = true
	debug_print_weapon_state()
	
func debug_print_weapon_state():
	print("Weapon state: ", WeaponState.find_key(current_weapon_state))
	print("Current sprite: ", current_animated_sprite)
