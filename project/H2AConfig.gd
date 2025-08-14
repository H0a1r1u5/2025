@tool
extends Resource
#to create this resource
class_name H2AConfig

# Enum declaration
enum Slot { NULL, TIME, SUN, FISH, HILL, CROSS, CHOICE }

# Real backing data
var placements: PackedInt32Array = PackedInt32Array() # Stores which enum is placed in each slot
var connections:= {} # Dictionary for slot

#similar to func _ready():
func _init():
	#one entry for each slot
	placements.resize(Slot.size())
	# Default all to NULL
	placements.fill(Slot.NULL)
	
	for slot in Slot.values():
		connections[slot] = []
	

# → A Godot function that tells the Inspector what properties to display and how.
func _get_property_list() -> Array:
	var properties: Array = [
		{
			"name": "placements",
			"type": TYPE_PACKED_INT32_ARRAY,#e.g. it’s a PackedInt32Array
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
		#loops through all slot indices except the very last one
	for slot in Slot.size() - 1:
		#creating the list of possible connection targets for the current slot.
		var available := PackedStringArray()
		# the variable holding the index
		#slot index= no. represent where the slot is in the array
		for dst in Slot.size():
			if dst <= slot:
				available.append("")
			else:
				#creates a list of names in inspetot
				available.append(Slot.keys()[dst])
				#Turns the list of strings into a singled strings.
		var available_str := ",".join(available)
		properties.append({
			"name": "connections/" + Slot.keys()[slot],#e.g., "connections/SUN"
			"type": TYPE_INT,
			"usage": PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_STORAGE,# editable in the editor
			"hint": PROPERTY_HINT_FLAGS,# show this integer as multiple checkboxes.
			"hint_string":available_str,
			
		})
	return properties

func _get(property):
		if property.begins_with("placements/"):
			property = property.trim_prefix("placements/")
			var index := int(Slot[property])
			return placements[index]
		
		if property.begins_with("connections/"):
			property = property.trim_prefix("connections/")#
			var index := int(Slot[property])
			var value := 0
			for dst in range(index + 1,Slot.size()):
				if dst in connections[index]:
					value |= (1<<dst)
			return value
			
		return null
	
	
func _set(property, value):
		if property.begins_with("placements/"): 
			#"placements/TIME" becomes "TIME"
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
		
func _set_connected(src: int, dst: int, connected: bool):
	# Get the list of connections for the source slot
	var src_arr := connections[src] as Array
	 # Get the list of connections for the destination slot
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
