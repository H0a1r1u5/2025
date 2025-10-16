extends Node

var cells = []
var pieces = []
var dragging = false # global dragging, to aviod dragging multiple pieces


const images = [
	"res://images/1.png",
	"res://images/2.png",
	"res://images/3.png",
	"res://images/3.png",
	"res://images/3.png"
]

enum DIFFICULTY {
	EASY,
	MEDIUM,
	HARD
}

const DIFFICULTY_VALUES = {
	DIFFICULTY.EASY: 3,
	DIFFICULTY.MEDIUM: 4,
	DIFFICULTY.HARD: 5
}

var chosen_difficulty = DIFFICULTY.MEDIUM
var grid_size = Vector2i(
	DIFFICULTY_VALUES[chosen_difficulty],
	DIFFICULTY_VALUES[chosen_difficulty]
)

func get_image():
	var image = Image.load_from_file(images.pick_random())
	return image

func find_cell(index: int):
	for cell in cells:
		if cell.index == index:
			return cell

func check_win():
	for piece in pieces:
		if piece.index != piece.cell_index:
			return
			print("YOU FIND REMEMBER")
