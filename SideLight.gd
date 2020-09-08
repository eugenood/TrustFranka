extends SpotLight

const FLICKER_TIME = 0.05

var time_since_flicker = 0

func _process(delta):
	time_since_flicker += delta
	if time_since_flicker > FLICKER_TIME:
		self.light_energy = rand_range(0, 5)
		time_since_flicker = 0
