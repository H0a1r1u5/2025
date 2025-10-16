extends Node2D
@onready var  arr = [$piece/TextureRect, $piece/TextureRect2, $piece/TextureRect3, $piece/TextureRect4, $piece/TextureRect5, $piece/TextureRect6, $piece/TextureRect7, $piece/TextureRect8, $piece/TextureRect9, $piece/TextureRect10, $piece/TextureRect11, $piece/TextureRect12]
# @export var list : Array[Texture]
func _ready() -> void:
	for node in arr:
		node.set_meta("Whether occupied",false)
	for node: TextureRect in $piece .get_children():
		node.gui_input.connect(func(event: InputEvent):
			if(event is InputEventScreenDrag):
				node.global_position += event.relative
			if event is InputEventScreenTouch:
				if !event.pressed:
					for cell in arr:
						print(cell.get_meta("Whether occupied"))
						#print(cell.global_position.distance_to(node.global_position))
						if cell.global_position.distance_to(node.global_position) < 300 and !cell.get_meta("Whether occupied", false):
							cell.set_meta("Whether occupied", true)
							node.global_position = cell.global_position
						pass
					pass
				else:
					for cell in arr:
						#print(cell.global_position.distance_to(node.global_position))
						if cell.global_position.distance_to(node.global_position) < 100 and cell.get_meta("Whether occupied", false):
							cell.set_meta("Whether occupied", false)
						
					pass
				pass
			pass
		)
		pass
