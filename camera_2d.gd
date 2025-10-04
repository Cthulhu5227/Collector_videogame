extends Camera2D

var zoom_speed = 0.1  # How fast to zoom
var min_zoom = 0.5    # Minimum zoom level (zoomed in)
var max_zoom = 2.0    # Maximum zoom level (zoomed out)

func _ready() -> void:
	make_current()
