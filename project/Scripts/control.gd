extends "res://dialogues/dialogue_manger.gd"
@onready var anim = $"../AnimationPlayer"
# Path to the next scene
@export var next_scene_path: String = "res://scenes/node_2d.tscn"

# Declare the flag variable at the top
var pending_scene_change: bool = false

func _ready():
	display_next_dialogue()  # start dialogue normally
	dialogue_changed.connect(_on_dialogue_changed)

func _on_dialogue_changed(index):
	# Show Overlay1 and Overlay2 after dialogue 4
	if index == 5:
		anim.play("fade_in_overlay1_2")

	# Show Overlay3 and Overlay4 after last dialogue
	if index == 6:
		anim.play("show_overlay3_4")
		
func _on_animation_finished(anim_name: String):
	# Only change scene after final overlay animation finishes
	if pending_scene_change and anim_name == "show_overlay3_4":
		get_tree().change_scene_to_file("res://scenes/node_2d.tscn")
	print("change")
