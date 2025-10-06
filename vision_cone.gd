extends Area2D
class_name VisionCone

@onready var enemy := get_node("../enemy_sprite")
var player_in_vision := false

signal player_spotted
signal player_left

func _ready():
	
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _on_body_entered(body):
	if body.name == "player" && _can_see_player(body):
		player_in_vision = true
		emit_signal("player_spotted")
		print("Player entered vision cone")

func _on_body_exited(body):
	if body.name == "player":
		player_in_vision = false
		emit_signal("player_left")
		print("Player left vision cone")
	


func _can_see_player(player: CharacterBody2D) -> bool:
	var space_state = get_world_2d().direct_space_state

	var query = PhysicsRayQueryParameters2D.new()
	query.from = global_position
	query.to = player.global_position
	query.exclude = [self, player]
	query.collide_with_areas = true
	query.collide_with_bodies = true

	var result = space_state.intersect_ray(query)

	if result:
			print("Ray hit:", result.collider.name)
		
	if result:
		# Something is blocking the view
		if result.collider != player:
			return false

	return true  # Either hit the player directly, or nothing at all
