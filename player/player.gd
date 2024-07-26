class_name Player
extends CharacterBody2D

@export var speed: float = 3
@export var sword_damage: int = 2
@export var health: int = 15
@export var death_prefab: PackedScene
@export var max_health: int = 15

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sword_area: Area2D = $SwordArea
@onready var hitbox_area: Area2D = $HitBoxArea
@onready var health_progress_bar: ProgressBar = $HealthProgressBar


signal meat_collected(value:int)


var input_vector: Vector2 = Vector2(0,0)

var is_running: bool = false
var was_running: bool = false
var is_attaking: bool = false
var attack_cooldown: float = 0.0
var hitbox_cooldown: float = 0.0

func _ready():
	GameManager.player = self
	meat_collected.connect(func(): GameManager.meat_counter += 1)
func _process(delta):
	GameManager.player_position = position
	update_hitbox_detection(delta)
	if is_attaking:
		attack_cooldown -= delta
		if attack_cooldown <= 0:
			is_attaking = false
			animation_player.play("idle")
	
	update_heath_bar()

func _physics_process(delta):
	if !is_attaking:
		read_input()
		
		# modifica a velocidade
		var target_velocity = input_vector * 100.0 * speed
		velocity = lerp(velocity, target_velocity, 0.5)
		move_and_slide()
		
		# atualizar is_running
		was_running = is_running
		is_running = not input_vector.is_zero_approx()
		
		#trocar animação
		if was_running != is_running:
			if is_running:
				animation_player.play("run")
			else: 
				animation_player.play("idle")
		
		# Girar sprite
		
		if input_vector.x > 0:
			sprite.flip_h = false
		elif input_vector.x < 0:
			sprite.flip_h = true
	
	# Ataque
	if Input.is_action_just_pressed("attack"):
		attack()
		

func read_input() -> void:
	# obtem o input vector
		input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down", 0.15)
		
func attack() -> void:
	if is_attaking:
		return
		
	animation_player.play("attack_side_1")
	attack_cooldown = 0.6
	is_running = false
	is_attaking = true
	
	
func deal_damage_to_enemies():
	var bodies = sword_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			var direction_to_enemy = (enemy.position - position).normalized()
			var attack_direction: Vector2
			if sprite.flip_h:
				attack_direction = Vector2.LEFT
			else:
				attack_direction = Vector2.RIGHT
			var dot_product = direction_to_enemy.dot(attack_direction)
			if dot_product > 0.4:
				enemy.damage(sword_damage)


func update_hitbox_detection(delta: float):
	hitbox_cooldown -= delta
	
	if hitbox_cooldown > 0 : return
	
	hitbox_cooldown = 0.5
	
	var bodies = hitbox_area.get_overlapping_bodies()
	for body in bodies:
		
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			var damage_amount = 1
			damage(damage_amount)
	

func damage(amount: int) -> void:
	if health <= 0: return
	
	health -= amount
	
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	
	if health <= 0:
		die()
	

func die() -> void:
	GameManager.end_game()
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	
	queue_free()


func heal(amount: int) -> int:
	health += amount
	if health > max_health:
		health = max_health
	return health

func update_heath_bar() -> void:
	health_progress_bar.max_value = max_health
	health_progress_bar.value = health
