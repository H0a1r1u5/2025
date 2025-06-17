extends CharacterBody2D
@onready var sprite_2d: AnimatedSprite2D = $sprite2d


const SPEED = 300.0

func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("right"):
		velocity.x = SPEED
		velocity.y = 0
		if(velocity.x > 1):
			sprite_2d.animation = "right_run"
		else:
			sprite_2d.animation = "right_default"
			
	elif Input.is_action_pressed("left"):
		velocity.x = -SPEED
		velocity.y = 0
		if(velocity.x <- 1):
			sprite_2d.animation = "left_run"
		else:
			sprite_2d.animation = "left_default"
		
			
	elif Input.is_action_pressed("up"):
		velocity.x = 0
		velocity.y = -SPEED
		if(velocity.y > 1):
			sprite_2d.animation = "back_run"
		else:
			sprite_2d.animation = "back_default"
		
	elif Input.is_action_pressed("down"):
		velocity.x = 0
		velocity.y = SPEED
		if(velocity.x <- 1):
			sprite_2d.animation = "run"
		else:
			sprite_2d.animation = "default"
		

	move_and_slide()
