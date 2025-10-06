extends Node2D

# centre the popup too, still play around with the design
var qte_inst
var qte_active := false
var qte_success := false

func init(qte_type, qte_diff):	
	match qte_type:
		0:
			call_other_script("res://quicktime/qte_catch.gd", qte_diff,[$Timer_Bar, $Catch_Bead, $QTE_Instr_Label, $QTE_Input_Label, $QTE_Container])
		1:
			call_other_script("res://quicktime/qte_match.gd", qte_diff, [$Timer, $Timer_Bar, $QTE_Instr_Label, $QTE_Input_Label, $QTE_Container])
		2:
			call_other_script("res://quicktime/qte_mash.gd", qte_diff,  [$Timer_Bar, $QTE_Instr_Label, $QTE_Input_Label, $QTE_Container])
		3:
			call_other_script("res://quicktime/qte_press.gd", qte_diff,  [$Timer, $Timer_Bar, $QTE_Instr_Label, $QTE_Input_Label, $QTE_Container])
		_:
			print("Warning:", qte_type, "is not an accepted QTE")


func receive_data_from_child(data):
	if get_parent():
		queue_free()
		get_parent().receive_data_from_child(data)
	return

# notes: see internal points for specific QTEs
# may also need to turn difficulty into an array to handle special modifiers for mash and catch
func call_other_script(path: String, difficulty: float, refs: Array):
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
