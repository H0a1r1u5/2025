extends StaticBody2D

@onready var talk_bubble = $talkbubble
@onready var dialogue = $dialouge

func _unhandled_input(event):
	if talk_bubble and event.is_action_pressed("interact"):
		dialogue.show_dialouge([
			{avatar="ghost", text= "“A stranger… in the Sandcrypt. Either bold or foolish.”"},
			{avatar="ghost", text= "I am Sir Caelum of the Ember Oath… or what remains of him."},
			{avatar="Mina", text= "You’re a knight? What happened here?"},
			{avatar="ghost", text= "This dungeon was once a tomb… now it hungers. I came seeking redemption — and the Gem of Solara. But I failed. My memories… fragments scattered like ashes."},
			{avatar="Mina", text= "The Gem of Solara… I need it to stop the Collapse. If you know where it is, help me find it."},
			{avatar="ghost", text= "Ah… The Collapse still looms above. So my fight was not in vain. But the Gem lies beyond locked doors — sealed by echoes of my past. Find them, and I shall guide you."},
		])


func _on_interactable_area_entered(area: Area2D) -> void:
	talk_bubble.show()


func _on_interactable_area_exited(area: Area2D) -> void:
	talk_bubble.hide()
"res://H2AConfig.gd"
