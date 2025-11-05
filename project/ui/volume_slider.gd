extends HSlider

@export var bus: String = "Master" # Audio channel name corresponding to volume control

@onready var bus_index := AudioServer.get_bus_index(bus) # Get audio channel


func _ready() -> void: # Initialize the slider and bind the value_changed signal
	# Initialize the slider value to the current volume
	value = Music.get_volume(bus_index)
	# Initialize the slider value to the current volume
	value_changed.connect(func(v: float):
		Music.set_volume(bus_index, v)
		)
		
