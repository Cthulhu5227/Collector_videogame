extends Node2D
var useable = false
@onready var label = $Label

func _ready():
	useable = false
	label.visible = false
	label.rotation =  -rotation
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") : 
		label.visible = true
		useable = true
		if !has_all_teeth():
			label.text = "Collect %d more teeth!" % (get_tree().get_nodes_in_group("bed").size() - Inventory.teeth)
		else:
			label.text = "Press E to Leave"
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") : 
		label.visible = false
		useable = false
		
func has_all_teeth():
	return get_tree().get_nodes_in_group("bed").size() <= Inventory.teeth
		

func _input(event: InputEvent):
	if useable and event.is_action_pressed("interact") and has_all_teeth():
		Ui.end_level()
