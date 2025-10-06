extends Node
var teeth = 0

func find_teeth():
	teeth = teeth+1
	Ui.update_teeth_counter()
	
func lose_teeth():
	teeth = 0
	Ui.update_teeth_counter()

func _on_teeth_got():
	pass
