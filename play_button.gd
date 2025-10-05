extends TextureButton


func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://level_menu.tscn")
	return


func _on_settings_button_pressed() -> void:
	pass # open settings


func _ready():
	Ui.get_node("audio_control").play_sound(2)
