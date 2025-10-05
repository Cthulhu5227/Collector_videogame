extends AudioStreamPlayer
func play_sound(case):
	match case:
		1:
			var new_sound = preload("res://sound_effects/Jett- discovery.mp3")
			stream = new_sound
			play()
		2:
			var new_sound = preload("res://sound_effects/Jett - menu music.mp3")
			stream = new_sound
			play()
