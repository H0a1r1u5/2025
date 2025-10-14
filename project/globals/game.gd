extends Node

const SAVE_PATH := "user://data.sav"
const CONFIG_PATH := "user://config.ini"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	load_config()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_scene(path: String, entry_point: String) -> void:
	var tree := get_tree()
	
	tree.change_scene_to_file(path)
	await tree.tree_changed
	
	for node in tree.get_nodes_in_group("entry_points"):
		if node.name == entry_point:
			tree.current_scene.update_player(node.global_position)
			break


func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

func save_config() -> void:
	var config := ConfigFile.new()
	
	config.set_value("audio", "master", Music.get_volume(Music.Bus.MASTER))
	config.set_value("audio", "sfx", Music.get_volume(Music.Bus.SFX))
	config.set_value("audio", "bgm", Music.get_volume(Music.Bus.BGM))
	
	config.save(CONFIG_PATH)

func load_config() -> void:
	var config := ConfigFile.new()
	config.load(CONFIG_PATH)
	
	Music.set_volume(
		Music.Bus.MASTER,
		config.get_value("audio","master", 0.5)
	)
	
	Music.set_volume(
		Music.Bus.MASTER,
		config.get_value("audio","sfx", 1.0)
	)
	Music.set_volume(
		Music.Bus.MASTER,
		config.get_value("audio","bgm", 1.0)
	)
