extends Node2D

@export var puzzle_image: Texture2D     # 你的完整拼图图片
@export var rows: int = 3               # 行数
@export var cols: int = 4               # 列数
@export var snap_threshold: float = 20  # 自动吸附的距离阈值

var pieces: Array = []                  # 存放所有拼图碎片
var snapped_count: int = 0              # 已拼好的碎片计数

signal puzzle_completed                 # 拼完的信号


func _ready():
	if puzzle_image == null:
		push_error("⚠️ Please specify the puzzle_image image in the Inspector！")
		return
	generate_pieces()
	print("✅ PuzzleManager ready! image=", puzzle_image)



func generate_pieces():
	var img: Image = puzzle_image.get_image()
	var piece_width = float(img.get_width()) / float(cols)
	var piece_height = float(img.get_height()) / float(rows)
	
	for y in range(rows):
		for x in range(cols):
			# === 自动裁剪图片 ===
			var piece_img = Image.new()
			piece_img.create(piece_width, piece_height, false, img.get_format())
			piece_img.blit_rect(
				img,
				Rect2i(x * piece_width, y * piece_height, piece_width, piece_height),
				Vector2i.ZERO
			)
			
			var tex = ImageTexture.create_from_image(piece_img)
			
			# === 用 Area2D 容器包 Sprite2D（能检测输入） ===
			var piece_area := Area2D.new()
			var sprite := Sprite2D.new()
			sprite.texture = tex
			sprite.position = Vector2(piece_width / 2, piece_height / 2)
			piece_area.add_child(sprite)
			add_child(piece_area)
			
			# === 添加碰撞检测区 ===
			var shape := CollisionShape2D.new()
			var rect_shape := RectangleShape2D.new()
			rect_shape.size = Vector2(piece_width, piece_height)
			shape.shape = rect_shape
			piece_area.add_child(shape)
			
			# === 设置目标位置 ===
			var target_pos = Vector2(x * piece_width + piece_width / 2, y * piece_height + piece_height / 2)
			piece_area.set_meta("target_position", target_pos)
			
			# === 随机初始位置 ===
			randomize_position(piece_area)
			
			# === 连接输入事件 ===
			piece_area.input_event.connect(_on_piece_input.bind(piece_area))
			
			pieces.append(piece_area)


func randomize_position(piece: Area2D):
	# 把碎片打乱到一个区域里
	var area = Rect2(Vector2(100, 100), Vector2(600, 400))
	piece.position = Vector2(
		randi_range(int(area.position.x), int(area.position.x + area.size.x)),
		randi_range(int(area.position.y), int(area.position.y + area.size.y))
	)


func _on_piece_input(piece: Area2D, viewport, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			piece.set_meta("dragging", true)
			piece.set_meta("offset", piece.position - get_global_mouse_position())
			piece.z_index = 10  # 让被拖动的碎片显示在最上面
		else:
			piece.set_meta("dragging", false)
			check_snap(piece)
			piece.z_index = 0
	elif event is InputEventMouseMotion:
		if piece.get_meta("dragging"):
			piece.position = get_global_mouse_position() + piece.get_meta("offset")


func check_snap(piece: Area2D):
	var target = piece.get_meta("target_position")
	if piece.position.distance_to(target) <= snap_threshold:
		piece.position = target
		piece.set_meta("dragging", false)
		snapped_count += 1
		
		if snapped_count >= pieces.size():
			_on_puzzle_completed()


func _on_puzzle_completed():
	print("🎉 Puzzle Completed!")
	emit_signal("puzzle_completed")
