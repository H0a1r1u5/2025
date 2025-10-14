
extends Node
# Automatically cut puzzle pictures (irregular edge version)

@export var source_path: String = "res://arts/puzzle/puzzle_template.png"
@export var output_folder: String = "res://arts/puzzle/pieces_irregular/"
@export var cols: int = 4
@export var rows: int = 3
@export var bump_size: float = 0.15  # 凹凸比例

func _ready():
	slice_irregular_puzzle()
	print("✅ Jigsaw cutting (irregular edges) completed!")

func slice_irregular_puzzle():
	var img = Image.load_from_file(source_path)
	if img == null:
		push_error("❌ Unable to load image: " + source_path)
		return
	
	var width = img.get_width()
	var height = img.get_height()
	var pw = width / cols
	var ph = height / rows

	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(output_folder))

	var count = 0
	for y in range(rows):
		for x in range(cols):
			var mask = Image.create(int(pw), int(ph), true, Image.FORMAT_RGBA8)
			mask.fill(Color(0, 0, 0, 0))
			_draw_piece_mask(mask, x, y, cols, rows, bump_size)
			
			var piece = Image.create(int(pw), int(ph), true, Image.FORMAT_RGBA8)
			piece.blit_rect(img, Rect2(x * pw, y * ph, pw, ph), Vector2.ZERO)

			for py in range(int(ph)):
				for px in range(int(pw)):
					var alpha = mask.get_pixel(px, py).a
					var color = piece.get_pixel(px, py)
					color.a = alpha
					piece.set_pixel(px, py, color)
			
			var path = output_folder + "piece_%d.png" % count
			piece.save_png(path)
			count += 1
	
	print("🧩 A total of %d irregular puzzle pieces were generated" % count)


func _draw_piece_mask(mask: Image, col: int, row: int, cols: int, rows: int, bump_ratio: float):
	var w = mask.get_width()
	var h = mask.get_height()
	var bump = int(min(w, h) * bump_ratio)
	mask.fill(Color(1, 1, 1, 1))
	
	if col > 0:
		_draw_bump(mask, Vector2(0, h/2), bump, "left")
	if col < cols - 1:
		_draw_bump(mask, Vector2(w, h/2), bump, "right")
	if row > 0:
		_draw_bump(mask, Vector2(w/2, 0), bump, "up")
	if row < rows - 1:
		_draw_bump(mask, Vector2(w/2, h), bump, "down")

func _draw_bump(mask: Image, center: Vector2, radius: float, direction: String):
	var sign = 1 if randf() > 0.5 else -1

	for y in range(-int(radius*1.5), int(radius*1.5)):
		for x in range(-int(radius*1.5), int(radius*1.5)):
			var px = center.x + x
			var py = center.y + y
			if px < 0 or py < 0 or px >= mask.get_width() or py >= mask.get_height():
				continue
			var dist = sqrt(x*x + y*y)
			var val = 1.0 - clamp(dist/radius, 0.0, 1.0)
			if val > 0:
				match direction:
					"left":
						if sign == 1 and x > 0: mask.set_pixel(px, py, Color(0,0,0,0))
						elif sign == -1 and x < 0: mask.set_pixel(px, py, Color(0,0,0,0))
					"right":
						if sign == 1 and x < 0: mask.set_pixel(px, py, Color(0,0,0,0))
						elif sign == -1 and x > 0: mask.set_pixel(px, py, Color(0,0,0,0))
					"up":
						if sign == 1 and y > 0: mask.set_pixel(px, py, Color(0,0,0,0))
						elif sign == -1 and y < 0: mask.set_pixel(px, py, Color(0,0,0,0))
					"down":
						if sign == 1 and y < 0: mask.set_pixel(px, py, Color(0,0,0,0))
						elif sign == -1 and y > 0: mask.set_pixel(px, py, Color(0,0,0,0))
