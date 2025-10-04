extends EnemyState
class_name EnemyDetected

var player : CharacterBody2D

var suspicion_meter := 0
var sus_rate := 1.0

# Stop and face towards player
func enter():
	enemy.velocity = Vector2(0, 0)
	#player = get_tree().get_first_node_in_group("Player")
	

func 
	
