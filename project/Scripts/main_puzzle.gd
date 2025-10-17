extends Node2D

@export var next_scene_path: String = "res://after_puzzle.tscn"
@export var bgm: AudioStream
@onready var  arr = [$cell/TextureRect, $cell/TextureRect2, $cell/TextureRect3, $cell/TextureRect4, $cell/TextureRect5, $cell/TextureRect6, $cell/TextureRect7, $cell/TextureRect8, $cell/TextureRect9, $cell/TextureRect10, $cell/TextureRect11, $cell/TextureRect12]
# @export var list : Array[Texture]

func _ready() -> void:
	for node in arr:
		node.set_meta("WhetherOccupied",false)
	for node: TextureRect in $piece .get_children():
		node.gui_input.connect(func(event: InputEvent):
			if(event is InputEventScreenDrag):
				node.global_position += event.relative
			if event is InputEventScreenTouch:
				if !event.pressed:
					for cell in arr:
						print(cell.get_meta("WhetherOccupied"))
						print(cell.global_position.distance_to(node.global_position))
						if cell.global_position.distance_to(node.global_position) < 300 and !cell.get_meta("WhetherOccupied", false):
							cell.set_meta("WhetherOccupied", true)
							node.global_position = cell.global_position
							check_puzzle_complete() #Check whether the spelling is complete
						
					
				else:
					for cell in arr:
						#print(cell.global_position.distance_to(node.global_position))
						if cell.global_position.distance_to(node.global_position) < 100 and cell.get_meta("WhetherOccupied", false):
							cell.set_meta("WhetherOccupied", false)
						
					
				
			
		)
		


	if bgm:
		Music.play_bgm(bgm)
		#globals
		
func check_puzzle_complete() -> void:
	print("🔍 Checking puzzle completion...")
	for i in range(arr.size()):
		var cell = arr[i]
		print("Cell", i, "=", cell.get_meta("WhetherOccupied", false))
		if !cell.get_meta("WhetherOccupied", false):
			return  # Exit directly if there is an unoccupied grid

	print("🎉 Puzzle complete!")
	get_tree().change_scene_to_file(next_scene_path)
