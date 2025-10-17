extends Area2D

@onready var talkbubble = $"../../../talkbubble"
@onready var player = $"../Player"

@export var next_scene_path: String = "res://scenes/next_level.tscn"

func _unhandled_input(event):
	# Only respond if bubble is visible (player is nearby)
	if talkbubble.visible and event.is_action_pressed("interact"):
		# Check if the player is in range
		if $"../Player" in $CollisionShape2D.get_overlapping_bodies():
			print("Player interacted — changing scene...")
			get_tree().change_scene_to_file("res://mini-game/Backgroud.tscn")

func _physics_process(delta: float) -> void:
	# Show the bubble only when the player is overlapping the interactable
	$talkbubble.visible = $"../Player" in $CollisionShape2D.get_overlapping_bodies()
