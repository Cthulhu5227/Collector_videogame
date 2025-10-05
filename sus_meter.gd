extends ProgressBar

@onready var enemy := owner


func _onready():
	# update progress bar settings here
	pass

func _process(delta):
	value = owner.sus_meter
	
	if value == 0.0:
		# Make meter invisible
		pass
	else:
		pass
		# Fill meter more
	
