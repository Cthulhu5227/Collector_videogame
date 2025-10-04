extends StaticBody2D

var qte_type: String # "catch", "match", "mash", "press"
var qte_diff: float # difficulty
var qte_input: Array # []

var qteing = true
var success = false

var quicktime_event = preload("res://quicktime/popup.tscn")

func receive_data_from_child(data):
	success = data
	qteing = false
	if success:
		Inventory.find_teeth()
		Ui.update_teeth_counter()
		get_tree().get_nodes_in_group("player")[0].cripple = false

	

func interact():
	await get_tree().create_timer(0.5).timeout
	make_quicktime()

func make_quicktime():
	qte_type = 'mash'
	qte_diff = 0.1
	qte_input = ["SPACE"]
	var qte_instance = quicktime_event.instantiate()
	add_child(qte_instance)
	qte_instance.init(qte_type, qte_diff, qte_input)
