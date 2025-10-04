extends EnemyState
class_name EnemyDetected

var player : CharacterBody2D

var sus_meter : float
var SUS_RATE := 1.0
var SUS_METER_MAX := 100.0

# Stop and face towards player
func enter():
	enemy.velocity = Vector2(0, 0)
	sus_meter = 0.0
	#player = get_tree().get_first_node_in_group("Player")
	

# Update sus meter. If threshold met, spot player, game ends
func update(delta):
	sus_meter += SUS_RATE * delta
	
	if sus_meter > SUS_METER_MAX:
		
		transitioned.emit(self, "enemyspotted")
	

# If time, update to rotate towards player
func physics_update(delta):
	pass
