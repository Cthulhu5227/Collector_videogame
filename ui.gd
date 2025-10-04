extends CanvasLayer
@onready var pause_menu = $pause_menu
@onready var teeth_counter = $teeth_counter/Label

	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		pause_menu.show(pause_menu)

func update_teeth_counter():
	teeth_counter.text = str(Inventory.teeth)
