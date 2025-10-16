extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var label = $CanvasLayer/Label


const base_text = "[E]"

var active_areas: Array[InteractionArea] = []
var can_interact: bool = true

func register_area(area: InteractionArea) -> void:
	if not active_areas.has(area):
		active_areas.append(area)

func unregister_area(area: InteractionArea) -> void:
	active_areas.erase(area)

func _process(_delta: float) -> void:
	if active_areas.size() > 0 and can_interact:
		active_areas.sort_custom(_sort_by_distance_to_player)
		var closest = active_areas[0]
		label.text = base_text + closest.action_name
		label.global_position = closest.global_position
		label.global_position.y -= 36
		label.global_position.x -= label.size.x / 2
		label.show()

func _sort_by_distance_to_player(area1, area2) -> bool:
	var dist1 = player.global_position.distance_to(area1.global_position)
	var dist2 = player.global_position.distance_to(area2.global_position)
	return dist1 < dist2

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and can_interact:
		if active_areas.size() > 0:
			can_interact = false
			label.hide()
			
			await active_areas[0].interact.call()
			
			can_interact = true

func _ready():
	print("InteractionManager children: ", get_children())
	if label == null:
		print("⚠️ Label is null! Check node path.")
	else:
		print("✅ Label found successfully!")
