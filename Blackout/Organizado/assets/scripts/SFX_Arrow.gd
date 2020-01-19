extends Control

func _ready():
	global.SFX_Arrow = self

# Load the music player node
onready var _player = $AudioStreamPlayer

# Calling this function will load the given track, and play it
func play(track_url : String):
    var track = load("res://assets/Sons/flecha.ogg")
    _player.stream = track
    _player.play()

# Calling this function will stop the music
func stop():
    _player.stop()