extends Node


func show(n : Node):
	n.visible = !n.visible
	if n.visible:
		Engine.time_scale = 0
	else:
		Engine.time_scale = 1
