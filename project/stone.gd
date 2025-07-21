extends Area2D


var enter = false

func _on_body_entered(body: Node2D) -> void:
	enter = true


func _on_body_exited(body: Node2D) -> void:
	enter = false
	
