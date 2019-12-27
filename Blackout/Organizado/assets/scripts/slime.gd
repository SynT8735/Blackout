extends KinematicBody2D

export (int) var speed

var velocity = Vector2.ZERO
var player = null

func _physics_process(delta):
    velocity = Vector2.ZERO
    if player:
        velocity = (player.global_position - global_position).normalized() * speed
    velocity = move_and_slide(velocity)

func _on_Area2D_body_entered(body):
    if body.name == "Player":
        player = body

func _on_Area2D_body_exited(body):
    if body.name == "Player":
        player = null

func take_damage():
	print("Slime took damage")
	$AnimationPlayer.play("taking_damage")