@tool
extends Resource
# Resource to store slot placements and connections
class_name H2AConfig

# Enum for different types of slots
enum Slot { NULL, TIME, SUN, FISH, HILL, CROSS, CHOICE }

# Array to store which type is in each slot
var placements: PackedInt32Array = PackedInt32Array()

# Dictionary to store connections between slots
var connections := {}

# Initialize default values for placements and connections
func _init():
	placements.resize(Slot.size())  # One entry per slot
	placements.fill(Slot.NULL)      # Default all to NULL
	for slot in Slot.values():
		connections[slot] = []      # Initialize empty connections

# Tell the editor which properties to show and how
func _get_property_list() -> Array:
	var properties: Array = [
		{
			"name": "placements",
			"type": TYPE_PACKED_INT32_ARRAY,
			"usage": PROPERTY_USAGE_STORAGE
		},
		{
			"name": "connections",
			"type": TYPE_DICTIONARY,
			"usage": PROPERTY_USAGE_STORAGE
		}
	]

	# Prepare dropdown options for placements
	var options := PackedStringArray(Slot.keys())
	var options_str := ",".join(options)

	# Add a property for each slot placement
	for slot in range(1, Slot.size()):
		properties.append({
			"name": "placements/" + Slot.keys()[slot],
			"type": TYPE_INT,
			"usage": PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_STORAGE,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": options_str
		})

	# Add properties for connections as checkboxes
	for slot in Slot.size() - 1:
		var available := PackedStringArray()
		for dst in Slot.size():
			if dst <= slot:
				available.append("")
			else:
				available.append(Slot.keys()[dst])
		var available_str := ",".join(available)

		properties.append({
			"name": "connections/" + Slot.keys()[slot],
			"type": TYPE_INT,
			"usage": PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_STORAGE,
			"hint": PROPERTY_HINT_FLAGS,
			"hint_string": available_str
		})

	return properties

# Return the value of a property for the editor or script
func _get(property):
	if property.begins_with("placements/"):
		property = property.trim_prefix("placements/")
		var index := int(Slot[property])
		return placements[index]

	if property.begins_with("connections/"):
		property = property.trim_prefix("connections/")
		var index := int(Slot[property])
		var value := 0
		for dst in range(index + 1, Slot.size()):
			if dst in connections[index]:
				value |= (1 << dst)
		return value

	return null

# Update a property when changed in the editor or via code
func _set(property, value):
	if property.begins_with("placements/"):
		property = property.trim_prefix("placements/")
		var index := int(Slot[property])
		placements[index] = value
		emit_changed()
		return true

	if property.begins_with("connections/"):
		property = property.trim_prefix("connections/")
		var index := int(Slot[property])
		for dst in range(index + 1, Slot.size()):
			_set_connected(index, dst, value & (1 << dst) != 0)
		emit_changed()
		return true

	return false

# Internal helper to add/remove bidirectional connections
func _set_connected(src: int, dst: int, connected: bool):
	var src_arr := connections[src] as Array
	var dst_arr := connections[src] as Array
	var src_idx := src_arr.find(dst)
	var dst_idx := dst_arr.find(src)

	if connected:
		if src_idx == -1:
			src_arr.append(dst)
		if dst_idx == -1:
			dst_arr.append(src)
	else:
		if src_idx != -1:
			src_arr.remove_at(src_idx)
		if dst_idx != -1:
			dst_arr.remove_at(dst_idx)
