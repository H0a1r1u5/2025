@tool
extends Node2D

const SLOT_TEXTURE = preload("res://arts/Objects/黑洞 (20250803065009).png")
const LINE_TEXTURE = preload("res://arts/Objects/黑线 (20250803065255) (1).png")

var _radius: float = 100.0
@export var radius: float:
	set(value):
		_radius = value
		queue_redraw()
	get:
		return _radius

var _config: H2AConfig
@export var config: H2AConfig:
	set(value):
		_config = value
		set_config(value)
	get:
		return _config

func set_config(v: H2AConfig):
	_config = v
	_update_board()

func _draw():
	for slot in range(H2AConfig.Slot.size()):
		draw_texture(SLOT_TEXTURE, _get_slot_position(slot) - SLOT_TEXTURE.get_size() / 2)

func set_radius(v: float) -> void:
	_radius = v
	queue_redraw()

func _update_board():
	for node in get_children():
		if node.owner == null:
			node.queue_free()

	if not _config:
		return

	for src in range(H2AConfig.Slot.size()):
		for dst in range(src + 1, H2AConfig.Slot.size()):
			if not dst in _config.connections[src]:
				continue
			var line := Line2D.new()
			add_child(line)
			line.add_point(_get_slot_position(src))
			line.add_point(_get_slot_position(dst))
			line.width = LINE_TEXTURE.get_size().y
			line.texture = LINE_TEXTURE
			line.texture_mode = Line2D.LINE_TEXTURE_TILE
			line.default_color = Color.WHITE
			line.show_behind_parent = true

func _get_slot_position(slot: int) -> Vector2:
	return Vector2.DOWN.rotated(TAU / H2AConfig.Slot.size() * slot) * _radius
