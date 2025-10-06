extends Node

var qte_instance_active := false

var timer
var timer_bar
var instruction_label
var input_label
var container_background

# timer bar stuff
var total_duration := 0
var total_amount := 0
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

var inputs_possible = ["U", "D", "L", "R"]

func initialize(difficulty, node_refs):	
	total_amount = difficulty[1]
	var input = get_parent().get_random_subset(inputs_possible, total_amount)
	# get qte elements
	timer = node_refs[0]
	timer_bar = node_refs[1]
	instruction_label = node_refs[2]
	input_label = node_refs[3]
	container_background = node_refs[4]
	
	var square_cont = node_refs[5]
	var match_cont = node_refs[6]
	square_cont.visible = false
	match_cont.visible = true
	
	# set up timer
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	total_duration = difficulty[0]
	timer.wait_time = total_duration
	
	# set up values
	match_input = input
	nec_progress = input.size()
	cur_input = input_map.get(match_input[cur_progress], Key.KEY_SPACE)
	
	# Start QTE
	instruction_label.bbcode_text = "[center][color=white]Match![/color][/center]"
	qte_instance_active = true
	timer.start()
	
	_update_input_label()
	
func _process(_delta):
	if qte_instance_active:
		var remaining_time = timer.time_left
		var scale: float = remaining_time / total_duration
		timer_bar.scale.x = scale
	
func _on_timer_timeout():
	if qte_instance_active:
		stun()
		cur_progress = 0
		cur_input = input_map.get(match_input[cur_progress], Key.KEY_SPACE)
		_update_input_label()
		timer.start()

func _input(event):
	cur_input = input_map.get(match_input[cur_progress], Key.KEY_SPACE)
	if (qte_instance_active):
		if (event is InputEventKey and event.pressed):
			if (event.keycode == cur_input): 
				cur_progress += 1
			else: 
				stun()
				timer.start()
				cur_progress = 0
			_update_input_label()
		
		if (cur_progress >= nec_progress):
			timer.stop()
			qte_instance_active = false
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

func stun():
	instruction_label.bbcode_text = "[center][color=yellow]Darn![/color][/center]"
	container_background.color = Color(0.424, 0.0, 0.02, 1.0)
	qte_instance_active = false
	timer.start()
	timer.stop()
	await get_tree().create_timer(1.0).timeout
	instruction_label.bbcode_text = "[center][color=white]Match![/color][/center]"
	container_background.color = Color(0.306, 0.0, 0.306, 1.0)
	qte_instance_active = true
	match_input = get_parent().get_random_subset(inputs_possible, total_amount)
	print(match_input)
	_update_input_label()
	timer.start()
	return
