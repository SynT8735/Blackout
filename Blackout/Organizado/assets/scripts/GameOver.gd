extends Control

onready var pause_button = get_tree().get_root().get_node("World/PauseMenu/pause")

func _on_Player_player_died():
	pause_button.hide()
	var new_pause_state = not get_tree().paused
	get_tree().paused = new_pause_state
	visible = new_pause_state

func _on_playAgain_pressed():
	get_tree().paused = false
	get_tree().change_scene('res://Scenes/World.tscn')


func _on_voltarMenu_pressed():
	get_tree().paused = false
	get_tree().change_scene('res://Scenes/Menu/Menu.tscn')
