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

var progress_ratio_speed := 0.2
var enemy_speed := 50
var rotation_speed := 0.5

# Wait time until the enemy turns around and continues on their path
@export var time_to_wait = 1.0
var remaining_time := 0.0

@export var sus_meter := 0.0
var SUS_RATE := 25
var SUS_METER_MAX := 100.0

var tracking_player := false
var STARTING_PROGRESS = 0.11

var MIN_PROGRESS_RATIO := 0.05
var MAX_PROGRESS_RATIO := 0.95

var prev_enemy_direction : float

var prev_enemy_pos : Vector2

var accel_distance = 0.05

var walking_pause = 0.0

var return_to_path = false

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
	if return_to_path:
		_return_to_path(delta)
	elif !tracking_player && sus_meter == 0.0:
		_bounce_movement(delta)
	elif tracking_player && sus_meter >= 0.0:
		_detecting_player(delta)
	elif !tracking_player:
		_losing_suspicion(delta)
	
# If first time tracking the player in a given sequence,
# save cone and sprite rotation
func _player_spotted():
	enemy_sprite.stop()
	if !tracking_player && sus_meter > 0.0:
		tracking_player = true
		rotation_speed = 0.75

	elif !tracking_player && sus_meter == 0.0:
		prev_enemy_direction = rotation
		prev_enemy_pos = global_position
		Ui.get_node("audio_control").play_sound(1)
		tracking_player = true
		rotation_speed = 0.75

func _player_left():
	tracking_player = false
	rotation_speed = 0.25
	
func _bounce_movement(delta):
	if walking_pause > 0.0:
		walking_pause = max(walking_pause - delta, 0.0)
	elif remaining_time > 0.0:
		remaining_time -= delta
		if remaining_time <= 0.0:
			enemy_sprite.stop()
			scale.x *= -1
			progress_ratio = clamp(progress_ratio, MIN_PROGRESS_RATIO, MAX_PROGRESS_RATIO)
			remaining_time = 0.0
			walking_pause = 0.5
	elif progress_ratio >= MAX_PROGRESS_RATIO || progress_ratio <= MIN_PROGRESS_RATIO:
		enemy_sprite.stop()
		progress_ratio_speed *= -1
		remaining_time = time_to_wait
	else:
		enemy_sprite.play()
		var distance_to_start = progress_ratio - MIN_PROGRESS_RATIO
		var distance_to_end = MAX_PROGRESS_RATIO - progress_ratio
		var distance_from_edge = min(distance_to_start, distance_to_end)
		
		var speed_factor = 1.0
		if distance_from_edge < accel_distance:
			speed_factor = clamp(distance_from_edge / accel_distance, 0.2, 1.0)
		progress_ratio += delta * progress_ratio_speed * speed_factor / (get_parent().curve.get_baked_length()/750)

func _detecting_player(delta):
	enemy_sprite.play()
	# Match the vision cone to the enemy's rotation
	# Rotate to face player
	var direction = player.global_position - global_position
	var target_angle = direction.angle()
	if progress_ratio_speed < 0:
		target_angle += PI
	rotation = lerp_angle(rotation, target_angle, delta * rotation_speed)
	
	if sus_meter > SUS_METER_MAX:
		Ui.game_over_screen()
		pass
	else:
		sus_meter += SUS_RATE * delta
		
func game_over():
	Ui.end_level()

func _losing_suspicion(delta):
	# Rotate to face player
	var direction = player.global_position - global_position
	var target_angle = direction.angle()
	if progress_ratio_speed < 0:
		target_angle += PI
	rotation = lerp_angle(rotation, target_angle, delta * rotation_speed)
		
	sus_meter = max(sus_meter - SUS_RATE * delta, 0.0)
	if sus_meter == 0.0:
		walking_pause = 0.5
		return_to_path = true

func _return_to_path(delta):
	if walking_pause > 0.0:
		walking_pause = max(walking_pause - delta, 0.0)
	else:
		rotation_speed = 0.75
		rotation = lerp_angle(rotation, prev_enemy_direction, delta * rotation_speed)
		if abs(rotation - prev_enemy_direction) < 0.05:
			rotation = prev_enemy_direction
			return_to_path = false
