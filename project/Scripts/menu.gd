class_name TitleScreen
extends Control

func _on_start_pressed() -> void:
	# Change to your opening scene
	get_tree().change_scene_to_file("res://scenes/Opening.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_setting_pressed() -> void:
	# Open a settings scene (optional)
	get_tree().change_scene_to_file("res://scenes/pause_screen.tscn")

func _on_about_pressed() -> void:
	# Open an about/credits scene (optional)
	get_tree().change_scene_to_file("res://scenes/about.tscn")

func _ready() -> void:
	Music.play_bgm(preload("res://assets/material/Characters/love-love-story-music-270165.mp3"))
