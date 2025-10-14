extends Area2D

@export var correct_position: Vector2
var dragging = false

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			get_parent().move_child(self, get_parent().get_child_count() - 1)
		elif not event.pressed:
			dragging = false
			check_correct()

func _process(_delta):
	if dragging:
		global_position = get_viewport().get_mouse_position()

func check_correct():
	if global_position.distance_to(correct_position) < 20:
		global_position = correct_position
		set_process(false)
		emit_signal("piece_placed")
