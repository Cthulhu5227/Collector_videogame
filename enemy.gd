extends PathFollow2D
class_name Enemy

## How to use the Enemy class
# Place a Path2D Node in the world and add enemy node as a child node
# to set paths for the enemy to patrol
# To create a stationary enemy just add the enemy node into the scene with
# a Path2D node


@onready var vision_cone = get_node("vision_cone")
@onready var enemy_sprite = get_node("enemy_sprite")
@onready var player = get_node("../../player")

var progress_ratio_speed := 0.3
var enemy_speed := 5
var rotation_speed := 0.5

# Wait time until the enemy turns around and continues on their path
@export var time_to_wait = 1.0
var remaining_time := 0.0

@export var sus_meter := 0.0
var SUS_RATE := 50
var SUS_METER_MAX := 100.0

var tracking_player := false
var STARTING_PROGRESS = 0.11

var MIN_PROGRESS_RATIO := 0.05
var MAX_PROGRESS_RATIO := 0.95


var prev_enemy_direction : float

var prev_enemy_pos : Vector2


func _ready():
	enemy_sprite.play()
	progress_ratio = MIN_PROGRESS_RATIO
	
	vision_cone.connect("player_spotted", _player_spotted)
	vision_cone.connect("player_left", _player_left)
	

# If not tracking player, continue along designated path
# If tracking player, stop moving and look towards player. Increment sus meter
# If not tracking player and still sus, still be stopped and look where player last was.
#	Decrement sus meter until 0
func _process(delta):
	if !tracking_player && sus_meter == 0.0:
		_bounce_movement(delta)
	elif tracking_player && sus_meter >= 0.0:
		_detecting_player(delta)
	elif !tracking_player:
		_losing_suspicion(delta)
	

# If first time tracking the player in a given sequence,
# save cone and sprite rotation
func _player_spotted():
	if !tracking_player && sus_meter > 0.0:
		tracking_player = true
	elif !tracking_player && sus_meter == 0.0:
		prev_enemy_direction = rotation
		prev_enemy_pos = global_position
		Ui.get_node("audio_control").play_sound(1)
		tracking_player = true

func _player_left():
	tracking_player = false
	

func _bounce_movement(delta):
	if remaining_time > 0.0:
		remaining_time -= delta
		if remaining_time <= 0.0:
			enemy_sprite.stop()
			scale.x *= -1
			position.y *= -1
			progress_ratio += progress_ratio_speed / 10
			remaining_time = 0.0
	elif progress_ratio >= MAX_PROGRESS_RATIO || progress_ratio <= MIN_PROGRESS_RATIO:
		enemy_sprite.stop()
		progress_ratio_speed *= -1
		remaining_time = time_to_wait
	else:
		enemy_sprite.play()
		progress_ratio += delta*progress_ratio_speed

func _detecting_player(delta):
	enemy_sprite.stop()
	# Match the vision cone to the enemy's rotation
	
	# Rotate to face player
	
	var direction = player.global_position - global_position
	var target_angle = direction.angle()
	if progress_ratio_speed < 0:
		target_angle += PI
	
	rotation = lerp_angle(rotation, target_angle, delta * rotation_speed)	
	
	# Move towards player
	global_position += (player.global_position - global_position).normalized() * enemy_speed * delta
	
	if sus_meter > SUS_METER_MAX:
		pass
		#print("Game Over")
		# End game
	else:
		sus_meter += SUS_RATE * delta

func _losing_suspicion(delta):
	enemy_sprite.stop()
	
	sus_meter -= SUS_RATE * delta
	if sus_meter <= 0.0:
		# Rotation, enemy position, and sus meter reset
		rotation = prev_enemy_direction
		global_position = prev_enemy_pos
		
		sus_meter = 0.0 
		
	
