extends Node2D

# centre the popup too, still play around with the design
var qte_inst
var qte_active := false
var qte_success := false

func init(qte_type, qte_diff):	
	var diff_array = []
	qte_type = 3
	qte_diff = 2
	match qte_type:
		0:
			if qte_diff == 1:
				diff_array = [175, 90]
			if qte_diff ==  2: 
				diff_array = [260, 106]
			if qte_diff ==  3:
				diff_array = [320, 112]
			call_other_script("res://quicktime/qte_catch.gd", diff_array, [$Timer_Bar, $Catch_Bead, $QTE_Instr_Label, $QTE_Input_Label, $QTE_Container])
		1:
			if qte_diff == 1:
				diff_array = [3, 4]
			if qte_diff ==  2: 
				diff_array = [3, 6]
			if qte_diff ==  3:
				diff_array = [3, 8]
			call_other_script("res://quicktime/qte_match.gd", diff_array, [$Timer, $Timer_Bar, $QTE_Instr_Label, $QTE_Match_Label, $QTE_Container, $Input_Container, $Match_Container])
		2:
			if qte_diff == 1:
				diff_array = [0.175, 0.001]
			if qte_diff ==  2: 
				diff_array = [0.1, 0.0015]
			if qte_diff ==  3:
				diff_array = [0.075, 0.002]
			call_other_script("res://quicktime/qte_mash.gd", diff_array, [$Timer_Bar, $QTE_Instr_Label, $QTE_Input_Label, $QTE_Container])
		3:
			if qte_diff == 1:
				diff_array = [2, 4]
			if qte_diff ==  2: 
				diff_array = [1.5, 5]
			if qte_diff ==  3:
				diff_array = [1, 7]
			call_other_script("res://quicktime/qte_press.gd", diff_array, [$Timer, $Timer_Bar, $QTE_Instr_Label, $QTE_Input_Label, $QTE_Container])
		_:
			print("Warning:", qte_type, "is not an accepted QTE")


func receive_data_from_child(data):
	if get_parent():
		queue_free()
		get_parent().receive_data_from_child(data)
	return

func call_other_script(path: String, difficulty: Array, refs: Array):
	qte_inst = load(path).new()
	add_child(qte_inst)
	if qte_inst.has_method("initialize"):
		qte_inst.initialize(difficulty, refs)
		
	else:
		print("Warning: Script", path, "has no 'initialize' method")
		return false
		

func get_random_subset(array: Array, count: int) -> Array:
	var result = []
	if array.is_empty():
		return result  # avoid division by zero if input is empty
	for i in count:
		var random_index = randi_range(0, array.size() - 1)
		result.append(array[random_index])
	return result
