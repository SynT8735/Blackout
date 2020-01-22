extends KinematicBody2D

export (int) var speed
export (int) var health = 15

onready var sprite = $AnimatedSprite
onready var MegaSlimeJumpingSound = get_tree().get_root().get_node("World/MegaSlimeJumpingSound")
onready var cutscene = get_tree().get_root().get_node("World/FinalCutscene/VideoPlayer")
onready var pause = get_tree().get_root().get_node("World/PauseMenu/pause")

var velocity = Vector2.ZERO
var player = null
var sfx = true
	
func SFX_off_received():
	sfx = false
	
func SFX_on_received():
	sfx = true

func _physics_process(delta):
	velocity = Vector2.ZERO
	if player:
		velocity = (player.global_position - global_position).normalized() * speed
	velocity = move_and_slide(velocity)
	die()
	anim()
	
func _on_Area2D_body_entered(body):
	if body.name == "Player":
		player = body
		if sfx:
			SFX_MegaSlime_Jumping.play("MegaSlime_Jump.ogg")

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		player = null
		if sfx:
			SFX_MegaSlime_Jumping.stop()

func take_damage():
	health -= 1
	print("Slime Boss Health: " + str(health))
	$AnimationPlayer.play("taking_damage")
	speed = 0
	yield(get_tree().create_timer(.1), "timeout")
	speed = 55
	
func anim():
	sprite.play("mega_slime")
	
func die():
	if health <= 0:
		print("Slime Died")
		queue_free()
		MusicController.stop()
		cutscene.show()
		pause.hide()
		cutscene.play()