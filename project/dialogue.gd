extends CanvasLayer
#Array[]:A built-in data structure that holds a sequence of elements
#var is used to declare a new variable,
#which is like a container that holds a value (like a number, text, object, etc.)
var dialouge = []
#current:counter
var current = 0
#when the scene is loaded(ready), the veriable content would get the node content 
@onready var content = $content

func _ready():
	#is a function
	hide_dialouge()
	show_dialouge([
		{text= "lolololol"},
		{text= "hahahihihi"},
		{text= "next scene"},
		])
	
func _input(event):
	if event.is_action_pressed("accept"):
		if current + 1 < dialouge.size():
			_show_dialouge(current + 1)
		else:hide_dialouge()
		
func hide_dialouge():
	content.hide()
	
func show_dialouge(_dialouge):
	dialouge = _dialouge
	content.show()
	_show_dialouge(0)

func _show_dialouge(index):
	current = index
	var current_dialouge = dialouge[current] 
	content.text = current_dialouge.text
	
	
