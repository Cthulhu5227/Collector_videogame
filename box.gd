extends StaticBody2D
var player_ref = null
var player_in_box = false

func interact():
	$Sprite2D.texture = preload("res://assets/full_box_test.png")


func leave_box():
	$Sprite2D.texture = preload("res://assets/empty_box_test.png")


func _input(event):
	if event.is_action_pressed("interact") and player_in_box :
		leave_box()
