extends HSlider

@export var bus: String = "Master"

@onready var bus_index := AudioServer.get_bus_index(bus)


func _ready() -> void:
	value = Music.get_volume(bus_index)
	
	value_changed.connect(func(v: float):
		Music.set_volume(bus_index, v)
		)
		
