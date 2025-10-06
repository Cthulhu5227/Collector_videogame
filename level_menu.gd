extends Control
var number_of_levels = 7
@onready var level_button = $level_button
@onready var level_container = $level_container

func _ready():
	for level in range(number_of_levels):
		var level_scene = load_level(level+1)
		var clone = level_button.duplicate()
		var function_access = func load_level(): 
			load(level_scene)
			get_tree().change_scene_to_file(level_scene)
			Inventory.lose_teeth()
			Ui.visible = true
		clone.connect("pressed", function_access)
		clone.visible = true
		clone.get_node("Label").text = "level %d" % (level+1)
		level_container.add_child(clone)

func load_level(level_number: int):
	var level_path = "res://levels/level_%d.tscn" % level_number
	return level_path
