extends Node

var qte_instance_active := false

var timer
var timer_bar
var instruction_label
var input_label

# timer bar stuff
var total_duration := 0
var nec_progress = 1
var cur_progress = 0
var cur_input = Key.KEY_SPACE

# input key
var match_input
var label_map = {
	"U": "↑",
	"D": "↓",
	"L": "←",
	"R": "→"
}
var input_map = {
	"U": Key.KEY_UP,
	"D": Key.KEY_DOWN,
	"L": Key.KEY_LEFT,
	"R": Key.KEY_RIGHT
}

func initialize(duration: float, input: Array, node_refs):	
	# get qte elements
	timer = node_refs[0]
	timer_bar = node_refs[1]
	instruction_label = node_refs[2]
	input_label = node_refs[3]
		
	# set up timer
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	total_duration = duration
	timer.wait_time = duration
	
	# set up values
	match_input = input
	nec_progress = input.size()
	
	# Start QTE
	instruction_label.bbcode_text = "[center][color=white]Match![/color][/center]"
	qte_instance_active = true
	timer.start()
	
	_update_input_label()
	
func _process(_delta):
	if qte_instance_active:
		cur_input = input_map.get(match_input[cur_progress], Key.KEY_SPACE)
		var remaining_time = timer.time_left
		var scale: float = remaining_time / total_duration
		timer_bar.scale.x = scale
	
func _on_timer_timeout():
	qte_instance_active = false
	input_label.bbcode_text = "[center][color=white]BOO[/color][/center]"
	if get_parent():
		get_parent().receive_data_from_child(false)
		queue_free()
	
func _input(event):
	if (qte_instance_active):
		if (event is InputEventKey and event.pressed):
			if (event.keycode == cur_input): 
				cur_progress += 1
			else: 
				cur_progress = 0
			_update_input_label()
		
		if (cur_progress >= nec_progress):
			timer.stop()
			qte_instance_active = false
			input_label.bbcode_text = "[center][color=white]YAY[/color][/center]"
			if get_parent():
				get_parent().receive_data_from_child(true)
				queue_free()
		
func _update_input_label():
	var display_str = ""
	for i in range(nec_progress):
		var arrow = label_map.get(match_input[i], "UNKNOWN")
		if i < cur_progress:
			display_str += "[color=gray]%s[/color]   " % arrow 
		else:
			display_str += "[color=white]%s[/color]   " % arrow

	input_label.bbcode_text = "[center]%s[/center]" % display_str
