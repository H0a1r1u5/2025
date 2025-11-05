extends Node

enum Bus { MASTER, SFX, BGM } # Define an audio channel enumeration for easy control of different volume levels

@onready var sfx: Node = $SFX # Store audio player node
@onready var bgm_player : AudioStreamPlayer = $BGMPlayer # Background Music Player
func play_sfx(name: String) -> void: # Play specified sound effect
	var player := sfx.get_node(name) as AudioStreamPlayer
	if not player:
		return
	player.play()

func play_bgm(stream: AudioStream) -> void: # Play background music
	# Play background music; skip if the same music is already playing
	if bgm_player.stream == stream and bgm_player.playing:
		return
	bgm_player.stream = stream
	bgm_player.play()
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func get_volume(bus_index: int) -> float: # Get the volume of a specified audio channel
	# Get the volume (linear value) of a specified audio channel
	var db := AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(db)


func set_volume(bus_index: int, v:float) -> void:
	# Set the volume of a specified audio channel
	var db := linear_to_db(v)
	AudioServer.set_bus_volume_db(bus_index, db)
