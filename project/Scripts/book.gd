extends Area2D
@onready var label: Label = $Label

func _physics_process(delta: float) -> void:
	label.visible = $"../player" in get_overlapping_bodies()
	if (Input.is_action_just_released("interact")) and  $"../player" in get_overlapping_bodies():
		get_tree().change_scene_to_file("res://scenes/Main_puzzle.tscn")
		pass
		
