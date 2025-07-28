@tool
extends Resource
class_name H2AConfig

# Enum declaration
enum Slot { NULL, TIME, SUN, FISH, HILL, CROSS, CHOICE }

# Real backing data
var placements: PackedInt32Array = PackedInt32Array()
var connections:= {}

func _init():
	placements.resize(Slot.size())
	placements.fill(Slot.NULL)
	
	for slot in Slot.values():
		connections[slot] = []
	

# 1. Define the dynamic property list
func _get_property_list() -> Array:
	var properties: Array = [
		{
			"name": "placements",
			"type": TYPE_PACKED_INT32_ARRAY,
			"usage": PROPERTY_USAGE_STORAGE,
		},
		{ 
			"name": "connections",
			"type": TYPE_DICTIONARY,
			"usage": PROPERTY_USAGE_STORAGE,
		},
	]
	var options := PackedStringArray(Slot.keys())
	var options_str :=",".join(options)
	for slot in range(1, Slot.size()):
		properties.append({
			"name": "placements/" + Slot.keys()[slot],
			"type": TYPE_INT,
			"usage": PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_STORAGE,
			"hint": PROPERTY_HINT_ENUM,#limit
			"hint_string":options_str,
			
		})
	return properties

func _get(property):
		if property.begins_with("placements/"):
			property = property.trim_prefix("placements/")
			var index := int(Slot[property])
			return placements[index]
		return null
	
	
func _set(property, value):
		if property.begins_with("placements/"):
			property = property.trim_prefix("placement/")
			var index := int(Slot[property])
			placements[index] = value
			emit_changed()
			return true
		return false
