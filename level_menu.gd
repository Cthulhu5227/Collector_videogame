extends Control
var number_of_levels = 3
@onready var level_button = $level_button
@onready var level_container = $level_container

func _ready():
	for level in range(number_of_levels):
		var level_scene = load_level(level+1)
		var clone = level_button.duplicate()
		var function_access = func load_level(): get_tree().change_scene_to_file(level_scene)
		clone.connect("pressed", function_access)
		clone.visible = true
		level_container.add_child(clone)
		


func load_level(level_number: int):
	var level_path = "res://levels/level_%d.tscn" % level_number
	var level_scene = load(level_path)
	if level_scene:
		print("Loaded:", level_path)
	else:
		print("Level not found:", level_path)
	return level_path
