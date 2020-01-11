extends Control


func _ready():
	MusicController.play("res://assets/Sons/flauta_ed.ogg")

# New Game
func _on_newgameTouch_released():
	get_tree().change_scene('res://Scenes/World.tscn')

func _on_New_Game_pressed():
	get_tree().change_scene('res://Scenes/World.tscn')

func _on_Exit_pressed():
	get_tree().quit()

func _on_Audio_toggled(button_pressed):
	if(button_pressed):
		MusicController.stop()
	else:
		MusicController.play("res://assets/Sons/flauta_ed.ogg")
