#This script belongs to a node of type CharacterBody2D
extends CharacterBody2D
#@onready: wait until the scene is ready (loaded)
#var sprite_2d a new variable called sprite_2d
#the variable is of type AnimatedSprite2D
#$sprite2d getting the node named sprite2d from the scene tree = get_node("sprite2d")
@onready var sprite_2d: AnimatedSprite2D = $sprite2d

const SPEED = 300.0
#delta: dela#delta: amount of time in seconds that has passed
# since the last fram was drawn. e.g(1 ÷ 60 ≈ 0.016 seconds per frame)
#float:integer with desimal 
#void: no return,  with return is like a vending machine: you put in money
# and get something back
# (delta: float) -> void: delta is a float with no return
#func _physics_process /Runs every physics frame (usually 60 times per second)
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
	#sets the current animation of the sprite_2d (an AnimatedSprite2D node) to "left_default".
			
	elif Input.is_action_pressed("up"):
		velocity.x = 0
		velocity.y = -SPEED
		if(velocity.y >- 1):
			sprite_2d.animation = "back_run"
		else:
			sprite_2d.animation = "back_default"
		
	elif Input.is_action_pressed("down"):
		velocity.x = 0
		velocity.y = SPEED
		if(velocity.y < 1):
			sprite_2d.animation = "front_run"
		else:
			sprite_2d.animation = "default"
		
#moves your character using its velocity, 
#and it automatically slides along walls or floors when it hits them.
	move_and_slide()
