extends KinematicBody2D

export (int) var speed
export (int) var health = 3

onready var sprite = $AnimatedSprite
onready var SlimeJumpingSound = get_tree().get_root().get_node("World/SlimeJumpingSound")

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
		SlimeJumpingSound.play()

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		player = null
		SlimeJumpingSound.stop()

func take_damage():
	health -= 1
	print("Slime Health: " + str(health))
	$AnimationPlayer.play("taking_damage")
	
func anim():
	sprite.play("slime")
	
func die():
	if health <= 0:
		print("Slime Died")
		queue_free()