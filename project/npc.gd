extends  StaticBody2D

onready var talk_bubble = $talkbubble
func _unhandled_input(event):
	if talk_bubble and event.is_action_pressed("interact"):
		dialogue.show_dialouge([
		{text= "lolololol"},
		{text= "hahahihihi"},
		{text= "next scene"},
		])

func _on_interactable_area_entered(area: Area2D) -> void:
	talk_bubble.show()


func _on_interactable_area_exited(area: Area2D) -> void:
	talk_bubble.hide()
