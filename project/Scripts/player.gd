extends CharacterBody2D

class_name Player

@onready var animated_sprite_2d: AnimationController = $AnimatedSprite2D # Player Animation Controller
@onready var pause_screen: Control = $CanvasLayer/PauseScreen # Pause Menu Node

const SPEED = 100.0

func _unhandled_input(event: InputEvent) -> void:
	# If the player presses the pause button, the pause menu will be displayed.
	if event.is_action_pressed("pause"):
		pause_screen.show_pause()

func _physics_process(delta: float) -> void: # Player movement and animation processing
	# Get the player input direction vector
	var direction = Input.get_vector("left", "right", "up", "down")
	
	# If input is received, move in the specified direction; otherwise, gradually decelerate.
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
#Play moving or idle animation
	if velocity != Vector2.ZERO:
		animated_sprite_2d.play_movement_animation(velocity)
	else:
		animated_sprite_2d.play_idle_animation()
	# Move Player
	move_and_slide()

# Restrict players to the area within the screen
	var min_x = 0
	var max_x = 1152
	var min_y = 0
	var max_y = 648

# Limit the player to the screen boundaries
	position.x = clamp(position.x, min_x, max_x)
	position.y = clamp(position.y, min_y, max_y)

# Triggered when the player comes into contact with an interactive object
func _on_interactable_body_entered(body: Node2D) -> void: # Collision handling between player and interactive objects
	pass # Replace with function body.
