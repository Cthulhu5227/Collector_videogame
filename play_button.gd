extends TextureButton


func _on_pressed() -> void:
	Ui.show()
	get_tree().change_scene_to_file("res://level.tscn")
	return


func _on_settings_button_pressed() -> void:
	pass # open settings
