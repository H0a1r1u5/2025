@tool
extends Node2D

const SLOT_TEXTURE = preload("res://arts/Objects/黑洞 (20250803065009).png")
const LINE_TEXTURE = preload("res://arts/Objects/黑线 (20250803065255) (1).png")

@export var radius: float = 100.0:
	set(value):
		radius = value
		queue_redraw()
	get:
		return radius
		
@export var _config: Resource
func set_config(value: Resource) -> void:
	_config = value
	queue_redraw()
	
func _draw():
	for slot in H2AConfig.Slot.size():
		draw_texture(SLOT_TEXTURE, _get_slot_position(slot) - SLOT_TEXTURE.get_size() / 2)

func set_radius(v: float) -> void:
	radius = v
	queue_redraw()

func _update_board():
	for node in get_children():
		if node.owner == null:
			node.queue_free()
	if not config:
		return


	for src in H2AConfig.Slot.size():
		for dst in range(scr + 1, H2Aconfig.Slot.size()):
			if not dst in config.connections[src]:
				continue
			var line := Line2D.new()
			add_child()
			line.add_point(get_slot_position(src))
			line.add_point(get_slot_position(dst))
			line.width = LINE_TEXTURE.get_size().y

func _get_slot_position(slot: int) -> Vector2:
	return Vector2.DOWN.rotated(TAU / H2AConfig.Slot.size() * slot) * radius
