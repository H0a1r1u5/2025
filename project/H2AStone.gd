@tool
extends Area2D
class_name H2AStone
signal interact(stone)


# Sprite2D will be created automatically
var sprite: Sprite2D

# Internal storage for slots
var _target_slot_internal: int = 0
var _current_slot_internal: int = 0


# Public variables with setters/getters
var target_slot: int:
	set(value):
		_set_target_slot(value)
	get:
		return _target_slot_internal

var current_slot: int:
	set(value):
		_set_current_slot(value)
	get:
		return _current_slot_internal
		
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Stone clicked:", name)
		do_interact()


func _ready():
	# Create a sprite if you don't have one
	if sprite == null:
		sprite = Sprite2D.new()
		add_child(sprite)
	_update_texture()

func _set_target_slot(v: int):
	_target_slot_internal = v
	if sprite != null:
		_update_texture()

func _set_current_slot(v: int):
	_current_slot_internal = v
	if sprite != null:
		_update_texture()


func _update_texture():
	if sprite == null:
		return  # Do nothing if sprite hasn't been created yet

	var index := _target_slot_internal
	if _target_slot_internal != _current_slot_internal:
		index += H2AConfig.Slot.size() - 1
	sprite.texture = load("res://arts/flags/chess_%02d.webp" % index)

func do_interact():
	emit_signal("interact", self)
