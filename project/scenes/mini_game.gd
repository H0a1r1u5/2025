extends Area2D

@onready var talk_bubble = $talkbubble
@export var next_scene_path: String = "res://mini-game/Backgroud.tscn"

var player_near := false

func _ready():
	talk_bubble.visible = false

# This is your function name from the signal
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_near = true
		talk_bubble.visible = true
		print("Player entered")

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_near = false
		talk_bubble.visible = false
		print("Player exited")

func _unhandled_input(event):
	if player_near and event.is_action_pressed("interact"):
		print("Changing scene...")
		get_tree().change_scene_to_file(next_scene_path)
