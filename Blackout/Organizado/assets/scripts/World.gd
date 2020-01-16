extends Node

func _ready():
	global.world = self

func spirittoggle():
	if $ss_cutscene.visible:
		$ss_cutscene.player_init("despawn")
	else:
		$ss_cutscene.show()
		$ss_cutscene.player_init("spawn")

func cutscene_end():
	$ss_cutscene.timer_start()

func _on_VideoPlayer_finished():
	get_tree().change_scene('res://Scenes/Menu/Menu.tscn')
