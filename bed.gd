extends StaticBody2D

var qte_type: String # "catch", "match", "mash", "press"
var qte_diff: float # difficulty
var qte_input: Array # []

var qteing = true
var success = false
var used = false

var quicktime_event = preload("res://quicktime/popup.tscn")

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
		await get_tree().create_timer(0.5).timeout
		Ui.get_node("audio_control").play_sound(1)
		make_quicktime()
	return

func make_quicktime():
	qte_type = 'press'
	qte_diff = 2
	qte_input = ["U", "D", "L"]
	var qte_instance = quicktime_event.instantiate()
	add_child(qte_instance)
	qte_instance.init(qte_type, qte_diff, qte_input)
