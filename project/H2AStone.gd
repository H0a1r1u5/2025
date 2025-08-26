@tool
extends Area2D
class_name H2AStone

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

# --- Setter functions ---
func _set_target_slot(v: int):
	_target_slot_internal = v
	_update_state()

func _set_current_slot(v: int):
	_current_slot_internal = v
	_update_state()

# --- Update function (logic only, no textures) ---
func _update_state():
	var index := _target_slot_internal
	if _target_slot_internal != _current_slot_internal:
		index += H2AConfig.Slot.size() - 1
	var current_texture_path: String = "res://arts/flags/棋子_01.webp"
	
