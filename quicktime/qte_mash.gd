extends Node

var qte_instance_active := false

var timer
var mash_bar
var instruction_label
var input_label

# timer bar stuff
var dec_speed := 0.0
var input_value := 0.0

var going 

# input key
var key_name

func initialize(difficulty: float, input: Array, node_refs):	
	# get qte elements
	mash_bar = node_refs[0]
	instruction_label = node_refs[1]
	input_label = node_refs[2]
	
	# set up mash bar
	mash_bar.scale.x = 0
	dec_speed = difficulty * 0.01
	input_value = difficulty
	
	# Start QTE
	instruction_label.bbcode_text = "[center][color=white]Mash![/color][/center]"
	qte_instance_active = true
	
	key_name = input[0]
	input_label.bbcode_text = "[center][color=white]%s[/color][/center]" % key_name
	
func _process(_delta):
	if qte_instance_active:
		mash_bar.scale.x = max(0, mash_bar.scale.x - dec_speed)

func _input(event):
	var key_value := OS.find_keycode_from_string(key_name)
	if (qte_instance_active) and (event is InputEventKey) and (event.pressed) and (event.keycode == key_value): 
		mash_bar.scale.x = min(1, mash_bar.scale.x + input_value)
		if mash_bar.scale.x == 1.0 and qte_instance_active:
			set_process_input(false)
			qte_instance_active = false
			input_label.bbcode_text = "[center][color=white]YAY[/color][/center]"
			if get_parent() and not qte_instance_active:
				get_parent().receive_data_from_child(true)
				queue_free()
				set_process(false)
