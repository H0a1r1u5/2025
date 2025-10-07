extends Area2D

signal book_opend

@export var interaction_key := "interact"

var player_in_area := false
var is_open := false

func _ready():
	$Sprite.texture = preload("res://assets/material/bestiary_book/bestiary_01.png")
	$InteractionLabel.visible = false
	
	var key_list = InputMap.action_get_events("interact")
	if key_list.size() > 0:
		var event = key_list[0]
		if event is InputEventKey:
			var key_name = OS.get_keycode_string(event.physcial_keycode)
			$InteractionLabel.text = "Press %s to open" % key_name
