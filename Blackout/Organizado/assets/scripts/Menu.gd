extends Control

# New Game
func _on_newgameTouch_released():
	get_tree().change_scene('res://Scenes/World.tscn')

func _on_New_Game_pressed():
	get_tree().change_scene('res://Scenes/World.tscn')

# Quit Button
func _on_quit_pressed():
	get_tree().quit()

func _on_quittouch_pressed():
	get_tree().quit()







