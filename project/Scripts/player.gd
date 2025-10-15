extends CharacterBody2D

class_name Player

@onready var animated_sprite_2d: AnimationController = $AnimatedSprite2D
@onready var pause_screen: Control = $CanvasLayer/PauseScreen

const SPEED = 100.0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		pause_screen.show_pause()

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		

	if velocity != Vector2.ZERO:
		animated_sprite_2d.play_movement_animation(velocity)
	else:
		animated_sprite_2d.play_idle_animation()
	
	move_and_slide()


func _on_interactable_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
