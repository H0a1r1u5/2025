extends Node2D

var total_pieces = 0
var placed_pieces = 0

func _ready():
	var pieces = $Pieces.get_children()
	total_pieces = pieces.size()
	for p in pieces:
		p.connect("piece_placed", Callable(self, "_on_piece_placed"))
	var folder = "res://art/puzzle/pieces_irregular/"
	var files = DirAccess.get_files_at(folder)
	for f in files:
		if f.ends_with(".png"):
			var piece_scene = preload("res://scenes/Piece.tscn").instantiate()
			var texture = load(folder + f)
			piece_scene.get_node("Sprite2D").texture = texture
			piece_scene.correct_position = Vector2(randf_range(200, 600), randf_range(200, 400))
			piece_scene.global_position = Vector2(randi()%500+50, randi()%400+50)
			$Pieces.add_child(piece_scene)

func _on_piece_placed():
	placed_pieces += 1
	if placed_pieces == total_pieces:
		_on_puzzle_complete()

func _on_puzzle_complete():
	print("Puzzle completed!")
	# 这里可以切换场景、播放动画、解锁剧情等
