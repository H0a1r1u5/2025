extends CanvasLayer
@onready var content = $content
@onready var avatar = $content/Avatar
#Array[]:A built-in data structure that holds a sequence of elements
#var is used to declare a new variable,
#which is like a container that holds a value (like a number, text, object, etc.)
const AVATAR_MAP = {
	"Mina": preload("res://arts/Characters/MinaA.png"),
	"ghost": preload("res://arts/Characters/aghost.png")

}

var dialouge = []
var current = 0


#when the scene is loaded(ready), the veriable content would get the node content 

func _ready():
	#is a function
	hide_dialouge()
	
func _unhandled_input(event):
	if event.is_action_pressed("accept"):
		if current + 1 < dialouge.size():
			_show_dialouge(current + 1)
		else:
			hide_dialouge()
		get_viewport().set_input_as_handled()
		
func hide_dialouge():
	if not content == null:
		content.hide()
	
func show_dialouge(_dialouge):
	dialouge = _dialouge
	content.show()
	_show_dialouge(0)

func _show_dialouge(index):
	current = index
	var current_dialouge = dialouge[current] 
	content.text = current_dialouge.text
	avatar.texture = AVATAR_MAP[dialouge.avatar]
	
