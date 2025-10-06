extends Node2D
@onready var tutorial = $Label

func _ready():
	tutorial.visible = false
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") : 
		tutorial.visible = true
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") : 
		tutorial.visible = false
		
func has_all_teeth():
	return get_tree().get_nodes_in_group("bed").size() >= Inventory.teeth
		

func _input(event: InputEvent):
	if tutorial.visible and event.is_action_pressed("interact") and has_all_teeth():
		Ui.end_level()
