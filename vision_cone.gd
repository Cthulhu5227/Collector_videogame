extends Area2D
class_name VisionCone

#@onready var player := get_node("../../player")

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
	
	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(enemy.position, player.position, 1)
	var result: Dictionary = space_state.intersect_ray(query)
	
	return result.size() != 0
