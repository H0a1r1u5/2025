extends Area2D

@onready var interaction_area = $InteractionArea
@onready var sprite = $Sprite2D

func _ready():
	interaction_area.interact = Callable(self, "_open_book")
	interaction_area.action_name = "open book"

func _open_book():
	sprite.frame = 1 if sprite.frame == 0 else 0
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/Main_puzzle.tscn")
