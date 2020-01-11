extends Control

# New Game
func _on_newgameTouch_released():
	get_tree().change_scene('res://Scenes/World.tscn')

func _on_New_Game_pressed():
	get_tree().change_scene('res://Scenes/World.tscn')

func _on_Exit_pressed():
	get_tree().quit()
