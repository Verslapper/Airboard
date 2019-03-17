extends Node

var time = 0
var time_mult = 1.0
var paused = true
var callMode = true
var callTimes = []
var responseTimes = []

func _ready():
	$HUD/TalkyLabel.set_text("\n" +
		"This game is Call and Response.\n" +
		"Set a rhythmic pattern with the spacebar.\n" +
		"Wait until the text turns grey," + 
		"then recreate the pattern as precisely as you can.\n\n" +
		"Try playing along with the beat of a song.\n" +
		"(Some gentle intros: Clap to Hey Mickey or strum to Smoke on the Water.)\n\n" +
		"Let's see what kind of band member you are!")

func _process(delta):
	if not paused:
		time += delta * time_mult
	
	if Input.is_action_just_pressed("ui_accept"):
		if paused:
			# Start pattern
			paused = false
			$HUD/TalkyLabel.set_text("")
			$HUD/CallLabel.show()
			$HUD/ResponseLabel.show()
			if callMode == true:
				$HUD/CallLabel.add_color_override("font_color", Color(0,1,0))
			else:
				$HUD/ResponseLabel.add_color_override("font_color", Color(0,1,0))
		else:
			# Add to pattern
			if callMode == true:
				callTimes.append(time)
				$HUD/CallLabel.set_text($HUD/CallLabel.get_text() + "\n" + str(stepify(time,0.001)))
			else:
				responseTimes.append(time)
				$HUD/ResponseLabel.set_text($HUD/ResponseLabel.get_text() + "\n" + str(stepify(time,0.001)))
	
	# Detect end of call (setting rhythm) phase
	if not paused && callMode == true && callTimes.size() > 0 && callTimes[(callTimes.size())-1] + 1.7 < time:
		callMode = false
		paused = true
		$HUD/CallLabel.add_color_override("font_color", Color(0.2,0.2,0.2))
		time = 0
	
	# Detect end of response (replicating rhythm) phase
	if not paused && callMode == false && responseTimes.size() >= callTimes.size():
		callMode = false
		paused = true
		$HUD/CallLabel.add_color_override("font_color", Color(0.2,0.2,0.2))
		time = 0
		doPatternMaths()
	
	# TODO: Is a space (beat) being held?
	# If so, extend the hold time of the note?
	
	# TODO: Has any keypress been hit?
	# If so, maybe track that count

func doPatternMaths():
	var closest = abs(responseTimes[0]-callTimes[0])
	var farthest = abs(responseTimes[0]-callTimes[0])
	var cumuloff = 0
	for i in callTimes:
		var diff = abs(responseTimes[i]-callTimes[i])
		cumuloff += diff
		if (diff < closest):
			closest = diff
		elif (diff > farthest):
			farthest = diff
	var average = cumuloff / callTimes.size()
	
	var horoscope = "";
	if (average > 0.3):
		horoscope = "You're the lead singer.\nNo one will care about your\nSouth Australian timing\nat the front of the stage."
	elif (average > 0.1):
		horoscope = "You're the lead guitarist.\nPlaying by the rules isn't rock'n'roll anyway.\nI bet your mum put your childhood art on the fridge\neven though you didn't colour inside the lines."
	elif (average > 0.05):
		horoscope = "You're the rhythm guitarist.\nYou've got the timing of a rooster.\nShame that nobody appreciates how good you are."
	elif (average > 0.02):
		horoscope = "You're the bass guitarist.\nYou've got the groove.\nYou're the glue of the band.\nI bet you have a great bass face doing it too."
	elif (average > 0):
		horoscope = "You're the drummer.\nYou're the conductor and the MVP.\nEveryone can count on you,\neven if you can only count to 4."
	
	$HUD/TalkyLabel.set_text("Tightest response: " + str(closest) + " sec\nShoddiest response: " + 
		str(farthest) + " sec\nAverage response: " + str(average) + " sec\nBeats laid down: " + str(callTimes.size()) +  "\n" +
		"Total distance from perfection: " + str(cumuloff) + " sec\n\n" +
		horoscope)