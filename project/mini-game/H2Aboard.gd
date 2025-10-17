@tool
extends Node2D

# Preload textures for the slots and connecting lines
const SLOT_TEXTURE = preload("res://arts/Drawings/黑洞 (20250803065009).png")
const LINE_TEXTURE = preload("res://arts/Drawings/黑线 (20250803065255) (1).png")

# Radius property to control spacing of slots in a circular layout
var _radius: float = 100.0
@export var radius: float:
	set(value):  # Update radius and redraw the board when changed
		_radius = value
		queue_redraw()
	get:  # Return current radius
		return _radius

# Store the board configuration (slot placements, connections, etc.)
var _config: H2AConfig
@export var config: H2AConfig:
	set(value):
		_config = value
		set_config(value)  # Apply new configuration to the board
	get:
		return _config

# Map to store stone instances for easy access
var _stone_map := {}

# Apply a new configuration to the board
func set_config(v: H2AConfig):
	_config = v
	_update_board()  # Rebuild the board visuals based on the config

# Draw the slot textures on the board
func _draw():
	for slot in range(H2AConfig.Slot.size()):
		# Draw each slot centered at its calculated position
		draw_texture(SLOT_TEXTURE, _get_slot_position(slot) - SLOT_TEXTURE.get_size() / 2)

# Allows changing radius dynamically
func set_radius(v: float) -> void:
	_radius = v
	queue_redraw()

# Update the board: clear old lines/stones and redraw based on config
func _update_board():
	# Remove any previously added children that are not owned
	for node in get_children():
		if node.owner == null:
			node.queue_free()
	
	# If no configuration is set, do nothing
	if not _config:
		return

	# Create lines for each connection between slots
	for src in H2AConfig.Slot.size():
		for dst in range(src + 1, H2AConfig.Slot.size()):
			if not dst in _config.connections[src]:
				continue
			var line := Line2D.new()
			add_child(line)
			line.add_point(_get_slot_position(src))
			line.add_point(_get_slot_position(dst))
			line.width = LINE_TEXTURE.get_size().y
			line.texture = LINE_TEXTURE
			line.texture_mode = Line2D.LINE_TEXTURE_STRETCH
			line.default_color = Color.WHITE
			line.show_behind_parent = true
	
	# Create stone instances for each slot and connect interaction signals
	for slot in range(1, H2AConfig.Slot.size()):
		var stone := H2AStone.new()
		add_child(stone)
		stone.target_slot = slot  # Logical goal for this stone
		stone.current_slot = config.placements[slot]  # Current placement
		stone.position = _get_slot_position(stone.current_slot)  # Set position on board
		_stone_map[slot] = stone
		stone.connect("interact", Callable(self, "_request_move"))

# Handle a stone being interacted with by the player
func _request_move(stone:H2AStone):
	# Determine which slots are free
	var available := H2AConfig.Slot.values()
	for s in _stone_map.values():
		available.erase(s.current_slot)
	# There should be exactly one free slot
	assert(available.size() == 1)
	var available_slot := available.front() as int
	_move_stone(stone, available_slot)

# Move a stone to a given slot with animation
func _move_stone(stone: H2AStone, slot: int):
	var tween := get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(stone, "position", _get_slot_position(slot), 0.2)
	tween.tween_interval(1.0)  # Wait before running callback
	tween.tween_callback(Callable(self, "_check"))  

	# Update the stone’s logical position
	stone.current_slot = slot

# Check if all stones are in their target positions
func _check():
	for stone in _stone_map.values():
		if stone.current_slot != stone.target_slot:
			return  # At least one stone is not in place
	# All stones are in place → change scene
	get_tree().change_scene_to_file("res://scenes/main.tscn")

# Calculate the position of a slot on the circular board
func _get_slot_position(slot: int) -> Vector2:
	return Vector2.DOWN.rotated(TAU / H2AConfig.Slot.size() * slot) * _radius
