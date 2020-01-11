extends Area2D

var directionx
var directiony
var speed

func init(dirx, diry, s, rot, offset):
	directionx = dirx
	directiony = diry
	speed = s
	rotation_degrees = rot
	if offset:
		$Sprite.position.y = 3
		$CollisionShape2D.position.y = 3
		$VisibilityNotifier2D.position.y = 3
	else:
		$Sprite.position.y = 0
		$CollisionShape2D.position.y = 0
		$VisibilityNotifier2D.position.y = 0

func _ready():
	
	$Sprite.flip_h = directionx == -1

func _physics_process(delta):
	global_position.x += directionx * speed
	global_position.y += directiony * speed
	print(position.y)
	

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Arrow_body_entered(body):
	match body.name:
		"Slime":
			body.take_damage()
			queue_free()
