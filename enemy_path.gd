extends PathFollow2D

@export var speed = 0.1

# Wait time until the enemy turns around and continues on their path
@export var time_to_wait = 3.0
var remaining_time = 0.0

func _process(delta):
	bounce_movement(delta)
	

func bounce_movement(delta):
	if remaining_time > 0.0:
		remaining_time -= delta
		return
	elif progress_ratio >= 0.99 || progress_ratio <= 0.01:
		speed *= -1
		progress_ratio += speed / 10
		remaining_time = time_to_wait
		
		
	progress_ratio += delta*speed
