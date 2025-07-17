extends Area2D


var enter = false

func _on_body_entered(body: Node2D) -> void:
	enter = true


func _on_body_exited(body: Node2D) -> void:
	enter = false
	
func _process(delta):
	if entered == true:
		if  Inpout.is_action_just_pressed("E")
			get_tree().chnage_scene("the scene:res:// paste here")
