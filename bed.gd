extends StaticBody2D

var qte_type: int # "catch", "match", "mash", "press"
var qte_diff: float # difficulty
var qte_input: Array # []

var qteing = true
var success = false
var used = false

var quicktime_event = load("res://quicktime/popup.tscn")

func receive_data_from_child(data):
	success = data
	qteing = false
	if success:
		Inventory.find_teeth()
		Ui.update_teeth_counter()
		get_tree().get_nodes_in_group("player")[0].cripple = false
		modulate = Color(0.5,0.5,0.5)
	else:
		used = false
		
func interact():
	if not used:
		used = true
		make_quicktime()
	return

func make_quicktime():
	qte_type = randi_range(0,3)
	qte_type = 1
	qte_diff = 6
	var qte_instance = quicktime_event.instantiate()
	qte_instance.position.x -= 150
	add_child(qte_instance)
	qte_instance.init(qte_type, qte_diff)
