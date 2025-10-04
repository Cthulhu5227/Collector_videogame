extends EnemyState
class_name EnemyIdle

var player : CharacterBody2D
var move_direction : Vector2
var wait_time : float

func enter():
	#player = get_tree().get_first_node_in_group("Player")
	pass
	
func physics_update(delta : float):
	if enemy:
		enemy.velocity = Vector2(0, 0) #move_direction * speed
		transitioned.emit(self, "enemypatrol")
	
	
