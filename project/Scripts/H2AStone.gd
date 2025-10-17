@tool
extends Area2D
# Stone object that can be moved between slots
class_name H2AStone

# Signal emitted when stone is clicked/interacted with
signal interact(stone)

# Sprite for visual representation
var sprite: Sprite2D

# Collision shape for detecting input events
var collision_shape: CollisionShape2D

# Internal storage for slot positions
var _target_slot_internal: int = 0
var _current_slot_internal: int = 0

# Public variable for target slot with setter/getter
var target_slot: int:
	set(value):
		_set_target_slot(value)
	get:
		return _target_slot_internal

# Public variable for current slot with setter/getter
var current_slot: int:
	set(value):
		_set_current_slot(value)
	get:
		return _current_slot_internal

# Handle mouse input events for interaction
func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			print(event)
			if event.button_index == MOUSE_BUTTON_RIGHT:
				print("Stone clicked:", name)
				do_interact()  # Emit interaction signal

# Initialize stone sprite and collision shape
func _ready():
	# Create sprite if it doesn’t exist
	if sprite == null:
		sprite = Sprite2D.new()
		add_child(sprite)
	_update_texture()

	# Create collision shape if it doesn’t exist
	if collision_shape == null:
		collision_shape = CollisionShape2D.new()
		var shape = CircleShape2D.new()
		shape.radius = 2000  # Large radius for easy clicking
		collision_shape.shape = shape
		add_child(collision_shape)

# Setter for target slot
func _set_target_slot(v: int):
	_target_slot_internal = v
	if sprite != null:
		_update_texture()  # Update visual texture when slot changes

# Setter for current slot
func _set_current_slot(v: int):
	_current_slot_internal = v
	if sprite != null:
		_update_texture()  # Update visual texture when slot changes

# Update sprite texture based on slot state
func _update_texture():
	if sprite == null:
		return  # Do nothing if sprite is not ready yet

	var index := _target_slot_internal
	# If stone is not in current slot, adjust index for alternate texture
	if _target_slot_internal != _current_slot_internal:
		index += H2AConfig.Slot.size() - 1
	# Load texture dynamically based on index
	sprite.texture = load("res://mini-game/flags/chess_%02d.webp" % index)

# Emit interaction signal to notify board or manager
func do_interact():
	emit_signal("interact", self)
