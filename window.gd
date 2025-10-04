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
