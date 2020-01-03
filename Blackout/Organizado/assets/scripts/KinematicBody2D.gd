extends KinematicBody2D

const arrow = preload("res://Scenes/Arrow.tscn")

export (int) var speed = 100
export (int) var knockback_speed = 500
export (int) var health = 10

onready var area = $Area2D
onready var sprite = $AnimatedSprite
onready var animation_player = $AnimationPlayer
onready var tween = $Tween

var touch_left := false
var touch_right := false
var touch_up := false
var touch_down := false

var charging_bow = false
var bow_power = 0
var bow_damage = 0

var timer = null
var arrow_delay = 0.5
var can_shoot = true

var velocity := Vector2()
var is_taking_damage = false

func _ready():
	#Cooldown for shooting
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(arrow_delay)
	timer.connect("timeout", self, "on_timeout_complete")
	add_child(timer)
	
func on_timeout_complete():
	can_shoot = true

func get_input():
	# Basically just turning input values into single boolean variables
	var move_right = (Input.is_action_pressed("ui_right") or touch_right) and not charging_bow
	var move_left =( Input.is_action_pressed("ui_left") or touch_left) and not charging_bow
	var move_up = (Input.is_action_pressed("ui_up") or touch_up) and not charging_bow
	var move_down = (Input.is_action_pressed("ui_down") or touch_down) and not charging_bow
	
	# Initializing variables
	var x_movement = 0
	var y_movement = 0
	
	# If moving horizontally
	if move_right or move_left:
		# Flips sprite if moving left only
		sprite.flip_h = move_left
		sprite.play("Run")
		# We only want to set x movement here because otherwise it allows the player 
		# to move diagonally which has strange behavior
		x_movement = int(move_right) - int(move_left)
	# If moving vertically
	elif move_up or move_down:
		# See note above x_movement
		y_movement = int(move_down) - int(move_up)
		if move_up:
			sprite.play("Walk_Up")
		elif move_down:
			sprite.play("Walk_Down")
	else:
		if Input.is_action_just_released("ui_up") and not charging_bow:
			sprite.play("Idle_Back")
		elif Input.is_action_just_released("ui_down") and not charging_bow:
			sprite.play("Idle_Front")
		elif (Input.is_action_just_released("ui_left") or Input.is_action_just_released("ui_right")) and not charging_bow:
			sprite.play("Idle")
	var move_to = Vector2(x_movement * speed, y_movement * speed)
	velocity = lerp(velocity, move_to, 0.2)

func get_attack_input():
	if Input.is_action_pressed("ui_accept") and not charging_bow && can_shoot:
		charging_bow = true
		velocity = Vector2.ZERO
		sprite.play("Attack_Bow")
		tween.interpolate_property(self, "bow_power", 3, 8, 5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
	elif Input.is_action_just_released("ui_accept") && can_shoot:
		charging_bow = false
		tween.stop(self, "bow_power")
		sprite.play("Idle")
		var arrow_instance = arrow.instance()
		var direction = -1 if sprite.flip_h else 1
		arrow_instance.init(direction, bow_power)
		get_parent().add_child(arrow_instance)
		arrow_instance.global_position = global_position
		arrow_instance.global_position.x += 16 * direction
		bow_power = 0
		
		#Disable Shoot
		can_shoot = false
		
		#Start Timer
		timer.start()
		
func _on_left_pressed():
	touch_left = true

func _on_right_pressed():
	touch_right = true

func _on_down_pressed():
	touch_down = true

func _on_up_pressed():
	touch_up = true

func _on_left_released():
	if not charging_bow:
		touch_left = false
		sprite.play("Idle")

func _on_right_released():
	if not charging_bow:
		touch_right = false
		sprite.play("Idle")

func _on_down_released():
	if not charging_bow:
		touch_down = false
		sprite.play("Idle_Front")

func _on_up_released():
	if not charging_bow:
		touch_up = false
		sprite.play("Idle_Back")

# warning-ignore:unused_argument
func _physics_process(delta):
	get_input()
	get_attack_input()
	check_for_overlap()
	die()
	velocity = move_and_slide(velocity)

# This function is needed because if the player is still under an enemy after
# taking damage then it will not trigger again because it only triggers when
# the player enters. 
func check_for_overlap():
	for body in area.get_overlapping_bodies():
		_on_Area2D_body_entered(body)

func _on_Area2D_body_entered(body):
	match body.name:
		"Slime":
			take_damage(body)

func take_damage(from_body):
	if not is_taking_damage:
		is_taking_damage = true
		var diff = global_position - from_body.global_position
		var direction = diff / Vector2(abs(diff.x), abs(diff.y))
		velocity = direction * Vector2(knockback_speed, knockback_speed)
		animation_player.play("taking_damage")
		yield(animation_player, "animation_finished")
		health -= 1
		print("Health: " + str(health))
		is_taking_damage = false
		
func die():
	if health <= 0:
		print("Player Died")
		get_tree().change_scene('res://Scenes/Menu/Menu.tscn')
	