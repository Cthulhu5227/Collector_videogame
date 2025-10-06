extends CharacterBody2D

var cur_velocity = Vector2.ZERO
var acceleration = 500
var max_speed = 150
var target = null
var selecting = false

# range to interact with object
var interact_range = 100

@onready var tutorial = $prompt

var start_position = position
var osc_time = 4.0

var cripple = false
var box_ref = null
var in_box = false

func _ready():
	$AnimatedSprite2D.play()
	Ui.get_node("music_player").play_song("Jett - Upbeat.mp3")
	Ui.get_node("audio_control").play_sound(0)
	Ui.visible = true
	Inventory.lose_teeth()

func _input(event):
	if cripple and event.is_action_pressed("interact") and in_box: #or (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT)):
		visible = true
		cripple = false
		box_ref = null
		$CollisionShape2D.disabled = false # cant be ssen in box
		in_box = false
		find_closest_box().leave_box()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			target = get_global_mouse_position()
			velocity = position.direction_to(target) * max_speed
			selecting = true
		else:
			selecting = false
			velocity = Vector2.ZERO
			target = null
			
	elif event is InputEventMouseMotion and selecting:
		target = get_global_mouse_position()
		velocity = position.direction_to(target) * max_speed
	
	elif event.is_action_pressed("interact"):
		for bed in get_tree().get_nodes_in_group("bed"):
			if global_position.distance_to(bed.global_position) < interact_range and not bed.used: 
				bed.interact()
				cripple = true
				return
		for box in get_tree().get_nodes_in_group("box"):
			if global_position.distance_to(box.global_position) < interact_range: 
				box.interact()
				Ui.get_node("audio_control").play_sound(3)
				visible = false
				cripple = true
				in_box = true
				$CollisionShape2D.disabled = true
				return

func _physics_process(delta):
	## check for boxes and such 
	$AnimationPlayer.play("oscilate")	
	if selecting:
		target = get_global_mouse_position()
	
	for bed in get_tree().get_nodes_in_group("bed"):
			if global_position.distance_to(bed.global_position) < interact_range and not bed.used: 
				tutorial.visible = true 
				break
			tutorial.visible = false 
			
	if not tutorial.visible:
		for box in get_tree().get_nodes_in_group("box"):
			if global_position.distance_to(box.global_position) < interact_range: 
				tutorial.visible = true 
				break
			tutorial.visible = false
	if not cripple:
		if target:
			cur_velocity = cur_velocity.move_toward((position.direction_to(target) * max_speed), acceleration * delta)
		else:
			cur_velocity = cur_velocity.move_toward(Vector2.ZERO, acceleration * delta)
		move_and_collide(cur_velocity * delta)

##### find closest box
func find_closest_box():
	var closest_box = null
	var closest_distance = INF  # Infinity, so any real distance will be smaller

	for box in get_tree().get_nodes_in_group("box"):
		if not box or box == self:
			continue  # Skip invalid nodes or self (if you're also in the group)

		var distance = position.distance_to(box.position)
		if distance < closest_distance:
			closest_distance = distance
			closest_box = box

	return closest_box
