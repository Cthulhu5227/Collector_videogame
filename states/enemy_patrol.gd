extends EnemyState
class_name EnemyPatrol

var player : CharacterBody2D

func enter():
	#player = get_tree().get_first_node_in_group("Player")
	pass

func physics_update(delta : float):
	if enemy:
		var move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		enemy.velocity = Vector2(5.0, 0)
	
	
