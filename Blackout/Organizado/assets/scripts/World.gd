extends Node

func _ready():
	global.world = self

func spirittoggle():
	if $ss_cutscene.visible:
		$ss_cutscene.hide()
	else:
		$ss_cutscene.show()

func cutscene_end():
	$ss_cutscene.queue_free()

func _on_VideoPlayer_finished():
	get_tree().change_scene('res://Scenes/Menu/Menu.tscn')
