extends CharacterBody2D

@export var speed: float = 3

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var input_vector: Vector2 = Vector2(0,0)

var is_running: bool = false
var was_running: bool = false
var is_attaking: bool = false
var attack_cooldown: float = 0.0

func _process(delta):
	if is_attaking:
		attack_cooldown -= delta
		if attack_cooldown <= 0:
			is_attaking = false
			animation_player.play("idle")

func _physics_process(delta):
	if !is_attaking:
		read_input()
		
		# modifica a velocidade
		var target_velocity = input_vector * 100.0
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
