extends Node

var qte_instance_active := false
var success = true

var catch_bar
var catch_bead
var instruction_label
var input_label

# bar
var bar_start_x = 0.0
var bar_end_x = 0.0

# bead movement
var start_x := 5.0
var target_x := 245.0
var moving_right := true

# input key
var press_input
var bead_speed := 0.0
var speed_constant := 50.0

func initialize(difficulty: float, input: Array, node_refs):	
	# get qte elements
	catch_bar = node_refs[0]
	catch_bead = node_refs[1]
	instruction_label = node_refs[2]
	input_label = node_refs[3]
	
	# set variables
	bead_speed = difficulty * speed_constant
	press_input = OS.find_keycode_from_string(input[0])
	
	# set up bar
	set_bar(catch_bar, difficulty)
	
	# set up bead
	catch_bead.visible = true
	
	# Start QTE
	instruction_label.bbcode_text = "[center][color=white]Catch![/color][/center]"
	input_label.bbcode_text = "[center][color=white]%s[/color][/center]" % input[0]
	qte_instance_active = true

func set_bar(bar, scale):
	var new_points = []
	var center_x = 125
	
	for point in bar.polygon:
		if point.x > center_x:
			bar_start_x = point.x - scale*50
			new_points.append(Vector2(bar_start_x, point.y))
		else:
			bar_end_x = point.x + scale*50
			new_points.append(Vector2(bar_end_x, point.y))
	bar.polygon = new_points

func _process(delta):
	if qte_instance_active:
		if moving_right:
			catch_bead.position.x += bead_speed * delta
			if catch_bead.position.x >= target_x:
				catch_bead.position.x = target_x
				moving_right = false
		else:
			catch_bead.position.x -= bead_speed * delta
			if catch_bead.position.x <= start_x:
				catch_bead.position.x = start_x
				moving_right = true

func _input(event):
	if (qte_instance_active) and (event is InputEventKey) and (event.pressed) and (event.keycode == press_input):
		var bead_pos = catch_bead.position.x
		print(bead_pos)
		print(bar_start_x)
		print(bar_end_x)
		if bead_pos >= bar_start_x and bead_pos <= bar_end_x:
			qte_instance_active = false
			input_label.bbcode_text = "[center][color=white]YAY[/color][/center]"
			if get_parent():
				get_parent().receive_data_from_child(true)
				queue_free()
		else: 
			bead_pos = start_x
