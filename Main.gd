extends Node

var time = 0
var time_mult = 1.0
var paused = false
# TODO: Something to store beat entries

func _ready():
	pass

func _process(delta):
	if not paused:
		time += delta * time_mult
	
	# TODO: Has a space (beat) been hit
	# If so, note it
	
	# TODO: Is a space (beat) being held?
	# If so, extend the hold time of the note?
	
	# TODO: Has any keypress been hit?
	# If so, maybe track that count