extends CanvasLayer

@onready var timer_label: Label = %TimerLabel
@onready var gold_label: Label = %GoldLabel
@onready var meat_label: Label = %MeatLabel



#func _ready():
	#GameManager.player.meat_collected.connect(on_meat_collected)

func _process(delta):
	#Atualizar tempo
	timer_label.text = GameManager.time_elapsed_string
	meat_label.text = str(GameManager.monster_defeated_counter)

func on_meat_collected(regeneration_value:int):
	print("aqui")
	#meat_counter += regeneration_value
	#meat_label.text = str(meat_counter)
