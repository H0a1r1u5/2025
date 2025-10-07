@tool
extends Node2D

const SLOT_TEXTURE = preload("res://arts/Objects/黑洞 (20250803065009).png")
const LINE_TEXTURE = preload("res://arts/Objects/黑线 (20250803065255) (1).png")

# Radius property for spacing slots in a circle
var _radius: float = 100.0
@export var radius: float: # Exported to adjust in inspector
	set(value):# Runs whenever radius changes
		_radius = value
		queue_redraw()# Redraw the Node2D so changes appear instantly
	get: # Returns the current radius
		return _radius

var _config: H2AConfig

@export var config: H2AConfig:
	set(value):
		_config = value
		set_config(value)  
	get:
		return _config
		
var _stone_map := {}


func set_config(v: H2AConfig):
	_config = v
	_update_board()  # Rebuild the board visuals

# Draws the slot icons for each position
func _draw():
	for slot in range(H2AConfig.Slot.size()):
		 # Center texture
		draw_texture(SLOT_TEXTURE, _get_slot_position(slot) - SLOT_TEXTURE.get_size() / 2)
		

func set_radius(v: float) -> void:
	_radius = v
	queue_redraw()
	
# Clears old lines and draws new connections based on the config
func _update_board():
	for node in get_children():
		if node.owner == null:
			node.queue_free()
# If no config is set, do nothing
	if not _config:
		return

# Create lines between connected slots
#src = source slot index (the slot you start from)
#dst is another node (slot) where a connection ends.
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
	
	for slot in range(1, H2AConfig.Slot.size()):
		var stone := H2AStone.new()
		add_child(stone)
		stone.target_slot = slot
		stone.current_slot = config.placements[slot]
		stone.position = _get_slot_position(stone.current_slot)
		_stone_map[slot] = stone
		stone.connect("interact", Callable(self, "_request_move"))

	
func _request_move(stone:H2AStone):
	print("requesting move for", stone.name)

	var available := H2AConfig.Slot.values()
	print("initial slots:", available)

	for s in _stone_map.values():
		print("erasing", s.current_slot)
		available.erase(s.current_slot)

	print("remaining slots:", available)

	assert(available.size() == 1)

	var available_slot := available.front() as int
	print("available slot:", available_slot)
	print("connections:", config.connections[stone.current_slot])

	if available_slot in config.connections[stone.current_slot]:
		print("connected — moving!")
		_move_stone(stone, available_slot)
	else:
		print("not connected, skip move")

func _move_stone(stone: H2AStone, slot: int):
	print("Attempting to move", stone.name, "to slot", slot)
	print("Inside tree?", stone.is_inside_tree())
	print("Current:", stone.position, "Target:", _get_slot_position(slot))

	var tween := get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(stone, "position", _get_slot_position(slot), 0.2)

	# Tween the position properttween.tween_property(stone, "position", _get_slot_position(slot), 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func _get_slot_position(slot: int) -> Vector2:
	return Vector2.DOWN.rotated(TAU / H2AConfig.Slot.size() * slot) * _radius
