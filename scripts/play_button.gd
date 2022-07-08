extends TextureButton

export(String, FILE) var next_scene_path: = ""

func _on_play_button_pressed():
	get_tree().change_scene(next_scene_path)
