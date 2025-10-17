extends Node2D

@export var bgm: AudioStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	if bgm:
		Music.play_bgm(bgm)
		#globals

		Music.play_bgm(bgm)
		#globals

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
