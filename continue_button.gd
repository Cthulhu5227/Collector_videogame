extends TextureButton

func _ready():
	pressed.connect(_on_button_pressed)

func _on_button_pressed():
	Ui.end_level_end()
	get_tree().change_scene_to_file("res://level_menu.tscn")
