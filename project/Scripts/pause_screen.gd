extends Control

var is_paused: bool = false # Is the game currently paused
var selected_option_index: int = 0
# GUI button reference
@onready var resume: Button = $V/Actions/H/Resume # Resume button
@export var player : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide() # Hide the pause menu during initialization
		# Automatically pause/resume the game when the pause menu is shown/hidden
	pass # Replace with function body.
	
	visibility_changed.connect(func ():
		get_tree().paused = visible
		)


func _input(event: InputEvent) -> void:
	# Press the pause button to display the menu
	if event.is_action_pressed("pause"):
		hide() 
		get_window().set_input_as_handled()

# This function displays the pause menu and highlights the Resume button
func show_pause()-> void:
	show()
	resume.grab_focus()




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_resume_pressed() -> void:
	hide()


func _on_quit_pressed() -> void:
	_save() #first save game
	get_tree().quit() #second quit the game


func _save() -> void:
	# Save player state
	if player == null:
		print("can't save")
		return

	var data = SceneData.new()
	data.player_position = player.global_position
	
	# Assuming you have a `facing_left` variable in Player.gd
	if player.has_method("is_facing_left"):
		data.is_facing_left = player.is_facing_left()
	
	ResourceSaver.save(data, "user://scene_data.res")
	print("saved!")


func _load() -> void:
	# Load player status
	var data = ResourceLoader.load("user://scene_data.res") as SceneData
	if data == null:
		print("can't load")
		return
		
	print("loaded!")
	if player != null:
		player.position = data.player_position
		#If the Player has a function to set the orientation
		if player.has_method("set_facing_left"):
			player.set_facing_left(data.is_facing_left)
