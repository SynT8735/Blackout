extends KinematicBody2D

export (int) var speed = 75
export (int) var health = 15

onready var sprite = $AnimatedSprite
onready var MegaSlimeJumpingSound = get_tree().get_root().get_node("World/MegaSlimeJumpingSound")

var velocity = Vector2.ZERO
var player = null

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
		MegaSlimeJumpingSound.play()

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		player = null
		MegaSlimeJumpingSound.stop()

func take_damage():
	health -= 1
	print("Slime Boss Health: " + str(health))
	$AnimationPlayer.play("taking_damage")
	
func die():
	if health <= 0:
		print("Slime Died")
		queue_free()
		
func anim():
	sprite.play("left")