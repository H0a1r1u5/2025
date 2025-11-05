extends Area2D
@onready var label: Label = $Label # Display the prompt text "Press E to interact"

func _physics_process(delta: float) -> void: # Detect player proximity and interaction key presses every frame
	# Display interactive prompts when players approach
	label.visible = $"../player" in get_overlapping_bodies()
	# When the player presses the interaction key and is within range, the game switches to the puzzle scene
	if (Input.is_action_just_released("interact")) and  $"../player" in get_overlapping_bodies():
		get_tree().change_scene_to_file("res://scenes/Main_puzzle.tscn")
		pass
		
