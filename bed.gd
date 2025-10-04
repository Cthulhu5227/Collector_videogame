extends StaticBody2D

func interact():
	modulate = Color(1,0,0)
	await get_tree().create_timer(2.5).timeout
	modulate = Color(0,0,1)
	Inventory.find_teeth()
	Ui.update_teeth_counter()
