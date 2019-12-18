extends KinematicBody2D

export (int) var speed
var max_health : = 3
var health : = max_health
var damage : = 1

var touch_left : = false
var touch_right : = false
var touch_up : = false
var touch_down : = false
var velocity : = Vector2()
var is_walking := false

func _ready():
	if max_health == 0:
		get_tree().change_scene('res://Scenes/Menu/Menu.tscn')

func get_input():
	if (not is_walking) and (Input.is_action_pressed("ui_right") or touch_right):
		velocity.x += 1
		$AnimatedSprite.flip_h = false
		is_walking = true
		$AnimatedSprite.play("Run")
	elif (not is_walking) and (Input.is_action_pressed("ui_left") or touch_left):
		velocity.x -= 1
		$AnimatedSprite.flip_h = true
		is_walking = true
		$AnimatedSprite.play("Run")
	elif (not is_walking) and (Input.is_action_pressed("ui_down") or touch_down):
		velocity.y += 1
		is_walking = true
		$AnimatedSprite.play("Walk_Down")
	elif (not is_walking) and (Input.is_action_pressed("ui_up") or touch_up):
		velocity.y -= 1
		is_walking = true
		$AnimatedSprite.play("Walk_Up")
		
	if Input.is_action_just_released("ui_right"):
		$AnimatedSprite.play("Idle")
		is_walking = false
		velocity.x = 0
		
	if Input.is_action_just_released("ui_left"):
		$AnimatedSprite.play("Idle")
		is_walking = false
		velocity.x = 0
		
	if Input.is_action_just_released("ui_up"):
		$AnimatedSprite.play("Idle_Back")
		is_walking = false
		velocity.y = 0
		
	if Input.is_action_just_released("ui_down"):
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("Idle_Front")
		is_walking = false
		velocity.y = 0
	
	velocity = velocity.normalized() * speed
	
func _on_left_pressed():
	touch_left = true

func _on_right_pressed():
	touch_right = true

func _on_down_pressed():
	touch_down = true

func _on_up_pressed():
	touch_up = true

func _on_left_released():
	touch_left = false
	$Sprite.flip_h = true
	$Sprite.play("Idle")
	velocity.x = 0
	is_walking = false

func _on_right_released():
	touch_right = false
	$Sprite.play("Idle")
	velocity.x = 0
	is_walking = false

func _on_down_released():
	touch_down = false
	$Sprite.play("Idle_Front")
	velocity.y = 0
	is_walking = false

func _on_up_released():
	touch_up = false
	$Sprite.play("Idle_Back")
	velocity.y = 0
	is_walking = false
	
func _on_Area2D_area_entered(area):
	max_health -= damage
	print(max_health)

# warning-ignore:unused_argument
func _physics_process(delta):
	get_input()
	_ready()
#	velocity = move_and_slide(velocity)
	move_and_collide(velocity * delta)
