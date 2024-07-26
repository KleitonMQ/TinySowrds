class_name MobSpawnner
extends Node2D

@export var creatures: Array[PackedScene]
var mobs_per_minute: float = 60.0


@onready var path_follow_2d = %PathFollow2D

var cooldown: float = 0.0

func _process(delta: float):
	if GameManager.is_game_over: return
	# frequencia de spawn
	cooldown -= delta
	if cooldown > 0:
		return
	
		#Checar se o ponto é valido
	var point = get_point()
	var world_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = point
	# O numero 1 no segundo parametro diz que se o ponto estiver colidindo com 
	# pelo menos 1 objeito já retorna o ponto do parameters para a array result.
	
	var result: Array = world_state.intersect_point(parameters, 1)
	if !result.is_empty(): return
	
	#Reseta cooldown
	var interval = 60.0 / mobs_per_minute
	cooldown = interval
	
	#instanciar a criatura
	var index = randi_range(0, creatures.size() -1)
	var creature_scene = creatures[index]
	var creature = creature_scene.instantiate()
	creature.global_position = point
	get_parent().add_child(creature)
	

func get_point() -> Vector2:
	path_follow_2d.progress_ratio = randf()
	return path_follow_2d.global_position
