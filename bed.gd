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
	

func interact():
	await get_tree().create_timer(0.5).timeout
	make_quicktime()

func make_quicktime():
	qte_type = 'press'
	qte_diff = 2
	qte_input = ["U", "D", "L"]
	var qte_instance = quicktime_event.instantiate()
	add_child(qte_instance)
	qte_instance.init(qte_type, qte_diff, qte_input)
