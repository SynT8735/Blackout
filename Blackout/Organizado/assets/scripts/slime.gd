extends KinematicBody2D

export (int) var speed
export (int) var health = 3

onready var sprite = $AnimatedSprite

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

func _on_Area2D_body_exited(body):
    if body.name == "Player":
        player = null

func take_damage():
	health -= 1
	print("Slime Health: " + str(health))
	$AnimationPlayer.play("taking_damage")
	
func die():
	if health <= 0:
		print("Slime Died")
		queue_free()
		
func anim():
	sprite.play("left")
