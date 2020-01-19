extends Node

var world
var MusicController
var SFX_Arrow
var SFX_Bow
var SFX_Flask
var SFX_MegaSlime_jumping
var SFX_Slime_jumping

var SFX_mute = false
var MUSIC_mute = false

func _ready():
	TranslationServer.set_locale("pt")