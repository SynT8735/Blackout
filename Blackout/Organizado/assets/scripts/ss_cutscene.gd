extends AnimatedSprite

func player_init(anim):
	$AnimationPlayer.play(anim)

func timer_start():
	$Timer.start()

func _on_Timer_timeout():
	queue_free()