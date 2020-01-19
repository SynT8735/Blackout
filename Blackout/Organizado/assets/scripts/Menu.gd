extends Control

signal SFX_off
signal SFX_on

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
		#MusicController.stop()
		AudioServer.set_bus_mute(1, true)
		global.MUSIC_mute = true
	else:
		#MusicController.play("res://assets/Sons/flauta_ed.ogg")
		AudioServer.set_bus_mute(1, false)
		global.MUSIC_mute = false
		
func _on_SFX_toggled(button_pressed):
	if(button_pressed):
#		SFX_Arrow.stop()
#		SFX_Bow.stop()
#		SFX_Flask.stop()
#		SFX_MegaSlime_Jumping.stop()
#		SFX_Slime_Jumping.stop()
#		emit_signal("SFX_off")
		AudioServer.set_bus_mute(2, true)
		global.SFX_mute = true
	else:
		#emit_signal("SFX_on")
		AudioServer.set_bus_mute(2, false)
		global.SFX_mute = false

func _on_change_lang_pressed():
	# little bit messy, it's simple switch between locales
	if TranslationServer.get_locale() == "pt":
		TranslationServer.set_locale("en")
		print("en locale")
	elif TranslationServer.get_locale() == "en":
		TranslationServer.set_locale("ru")
		print("ru locale")
	elif TranslationServer.get_locale() == "ru":
		TranslationServer.set_locale("pt")
		print("pt locale")


