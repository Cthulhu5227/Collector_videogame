extends CharacterBody2D
var  STOP_THRESHOLD = 0.0
var SPEED = 100
var target = null
var selecting = false
var interact_range = 50

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			modulate = Color(1,0,0)
			target = get_global_mouse_position()
			selecting = true
		else:
			selecting = false
			
			modulate = Color(1,1,1)	
			target = null
	elif event is InputEventMouseMotion and selecting:
		target = get_global_mouse_position()
		
	elif event.is_action_pressed("interact"):
		for bed in get_tree().get_nodes_in_group("bed"):
			if global_position.distance_to(bed.global_position) < interact_range: 
				bed.interact()
	
func _physics_process(delta):
	
	if target != null and position.distance_to(target) > STOP_THRESHOLD:
		velocity = position.direction_to(target) * SPEED
	else:
		velocity = Vector2.ZERO
	
	move_and_collide(velocity * delta)
		
	# Flip sprite based on movement direction
	#if abs(velocity.x) > 0.1:
	#	$Sprite2D.flip_h = velocity.x < 0
	#if velocity.length() > 0.1:
	#	$AnimationPlayer.play("running")
	#else:
	#	$AnimationPlayer.play("idle")
