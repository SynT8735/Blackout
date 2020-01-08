extends Control

var music = preload("res://assets/HUD/Icons_W/sprite_0.png")
var mute_music = preload("res://assets/HUD/Icons_W/sprite_1.png")
var sfx = preload("res://assets/HUD/Icons_W/sprite_2.png")
var mute_sfx = preload("res://assets/HUD/Icons_W/sprite_3.png")

onready var music_button = get_node("TitleScreen/Audio")
onready var sfx_button = get_node("TitleScreen/SFX")

# New Game
func _on_newgameTouch_released():
	get_tree().change_scene('res://Scenes/World.tscn')

func _on_New_Game_pressed():
	get_tree().change_scene('res://Scenes/World.tscn')

func _on_Exit_pressed():
	get_tree().quit()

func _on_Audio_pressed():
	music_button.pressed = false
	
	if music_button.pressed == false:
		music_button.set_texture(mute_music)
	if music_button.pressed == true:
		music_button.set_texture(music)

func _on_SFX_pressed():
	sfx_button.pressed = false
	
