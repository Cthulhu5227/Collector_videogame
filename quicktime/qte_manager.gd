extends Node2D

var qte_type: String # "catch", "match", "mash", "press"
var qte_diff: float # difficulty
var qte_input: Array # []

# do something with these
var qte_active := false
var qte_success := false

func _ready():	
	match qte_type:
		"catch":
			call_other_script("res://quicktime/qte_catch.gd", qte_diff, qte_input,[])
		"match":
			call_other_script("res://quicktime/qte_match.gd", qte_diff, qte_input, [$Timer, $Timer_Bar, $QTE_Instr_Label, $QTE_Input_Label])
		"mash":
			call_other_script("res://quicktime/qte_mash.gd", qte_diff, qte_input, [$Timer_Bar, $QTE_Instr_Label, $QTE_Input_Label])
		"press":
			call_other_script("res://quicktime/qte_press.gd", qte_diff, qte_input, [$Timer, $Timer_Bar, $QTE_Instr_Label, $QTE_Input_Label])
		_:
			print("Warning:", qte_type, "is not an accepted QTE")

func call_other_script(path: String, difficulty: float, input: Array, refs: Array):
	var qte_inst = load(path).new()
	add_child(qte_inst)
	if qte_inst.has_method("initialize"):
		qte_inst.initialize(difficulty, input, refs)
	else:
		print("Warning: Script", path, "has no 'initialize' method")
