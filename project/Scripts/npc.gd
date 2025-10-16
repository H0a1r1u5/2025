extends StaticBody2D

@onready var talkbubble = $talkbubble
@onready var dialogue = $"../dialouge"



func _unhandled_input(event):
	if talkbubble.visible and event.is_action_pressed("interact"):
		print($Interactable.get_overlapping.bodies())
		if $"../Player" in $Interactable.get_overlapping_bodies():
			dialogue.show_dialouge([
				{avatar="ghost", text= "“You have wandered into the Dungeon of Memories.”"},
				{avatar="ghost", text= "This place holds the echoes of what was once yours."},
				{avatar="Mina", text= "What is this place? Why does it feel… familiar?"},
				{avatar="ghost", text= "Because your past sleeps here, beneath the stones."},
				{avatar="Mina", text= "Many tombs lie before you, but only one remembers your name."},
				{avatar="ghost", text= "Find the right tomb, and you will find the way home."},
				{avatar="Mina", text= "And when I find it?"},
				{avatar="ghost", text= "You must return what was taken."},
				{avatar="ghost", text= "Place the stones onto their true resting places on the tomb."},
				{avatar="ghost", text= "When each stone is where it belongs… the truth will awaken."},
			])
		
func _physics_process(delta: float)-> void:
	$talkbubble.visible = $"../Player" in $Interactable.get_overlapping_bodies()
