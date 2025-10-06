extends TextureButton

func _ready():
	pressed.connect(_on_button_pressed)

# Retry level
func _on_button_pressed():
	Ui.retry_level()
	get_tree().reload_current_scene()
