extends AudioStreamPlayer
func play_sound(case):
	match case:
		1:
			var new_sound = preload("res://sound_effects/Jett Schreiber - discovery(3).mp3")
			stream = new_sound
			play()
