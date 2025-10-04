extends CharacterBody2D
var  STOP_THRESHOLD = 0.0
var SPEED = 100
var target = null
var selecting = false

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			modulate = Color(1,0,0)
			target = get_viewport().get_mouse_position()
			selecting = true
		else:
			selecting = false
			target = null
	elif event is InputEventMouseMotion and selecting:
		target = get_viewport().get_mouse_position()
func _physics_process(delta):
	
	if target != null and position.distance_to(target) > STOP_THRESHOLD:
		velocity = position.direction_to(target) * SPEED
	
	move_and_collide(velocity * delta)
		
	# Flip sprite based on movement direction
	#if abs(velocity.x) > 0.1:
	#	$Sprite2D.flip_h = velocity.x < 0
	#if velocity.length() > 0.1:
	#	$AnimationPlayer.play("running")
	#else:
	#	$AnimationPlayer.play("idle")
