extends Control

var is_paused: bool = false
var selected_option_index: int = 0
# GUI button reference
@onready var resume: Button = $V/Actions/H/Resume

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	pass # Replace with function body.
	
	visibility_changed.connect(func ():
		get_tree().paused = visible
		)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		hide()
		get_window().set_input_as_handled()
# Called when the pause screen is 
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
	get_tree().quit()
