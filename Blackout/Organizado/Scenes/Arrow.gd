extends Area2D

var direction
var speed

func init(dir, s):
	direction = dir
	speed = s

func _ready():
	$Sprite.flip_h = direction == -1

func _physics_process(delta):
	global_position.x += direction * speed


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Arrow_body_entered(body):
	match body.name:
		"Slime":
			body.take_damage()
			queue_free()
