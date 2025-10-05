extends AudioStreamPlayer

func play_song(song_name):
	var new_sound = load("res://sound_effects/%s" % song_name)
	stream = new_sound
	play()
