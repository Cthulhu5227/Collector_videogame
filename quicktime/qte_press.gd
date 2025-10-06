extends Node

var qte_instance_active := false

var timer
var timer_bar
var instruction_label
var input_label
var container_background

# timer bar stuff
var total_quantity = 0
var total_duration := 0
var nec_progress = 1
var cur_progress = 0
var cur_input = Key.KEY_SPACE

# input key
var press_input

var capital_letters = [
	"A", "B", "C", "D", "F", "G", "H", "I", "J", "K", "L", "M",
	"N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
]

func initialize(duration, node_refs):	
	# need to actually divide them
	total_quantity = duration
	var input = get_parent().get_random_subset(capital_letters, total_quantity)
	
	# get qte elements
	timer = node_refs[0]
	timer_bar = node_refs[1]
	instruction_label = node_refs[2]
	input_label = node_refs[3]
	container_background = node_refs[4]
	
	# set up timer
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	total_duration = duration
	timer.wait_time = duration
	
	# set up values
	nec_progress = input.size()
	press_input = input
	cur_input = OS.find_keycode_from_string(press_input[cur_progress])
	
	# Start QTE
	instruction_label.bbcode_text = "[center][color=white]Press![/color][/center]"
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
		cur_input = OS.find_keycode_from_string(press_input[cur_progress])
		_update_input_label()
		timer.start()
	
func _input(event):
	if (qte_instance_active) and (event is InputEventKey) and (event.pressed):
		if (event.keycode == cur_input):
			cur_progress += 1
			if cur_progress >= nec_progress:
				timer.stop()
				qte_instance_active = false
				if get_parent():
					get_parent().receive_data_from_child(true)
					queue_free()
			else: 
				cur_input = OS.find_keycode_from_string(press_input[cur_progress])
				_update_input_label()
				timer.start()
		else:
			stun()
			cur_progress = 0
			cur_input = OS.find_keycode_from_string(press_input[cur_progress])
			_update_input_label()
			timer.start()
	
func _update_input_label():
	var display_str = ""
	display_str += "[color=gray]%s[/color] " % press_input[cur_progress] 
	input_label.bbcode_text = "[center]%s[/center]" % display_str.strip_edges()

func stun():
	instruction_label.bbcode_text = "[center][color=yellow]Darn![/color][/center]"
	container_background.color = Color(0.424, 0.0, 0.02, 1.0)
	qte_instance_active = false
	timer.start()
	timer.stop()
	await get_tree().create_timer(1.0).timeout
	instruction_label.bbcode_text = "[center][color=white]Press![/color][/center]"
	container_background.color = Color(0.306, 0.0, 0.306, 1.0)
	qte_instance_active = true
	timer.start()
	return
