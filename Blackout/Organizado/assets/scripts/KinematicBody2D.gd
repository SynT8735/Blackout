extends KinematicBody2D

const arrow = preload("res://Scenes/Arrow.tscn")
const full_heart = preload("res://assets/HUD/heart.png")
const half_heart = preload("res://assets/HUD/half_heart.png")
const empty_heart = preload("res://assets/HUD/dead_heart.png")
const full_bolt = preload("res://assets/HUD/energy.png")
const empty_bolt = preload("res://assets/HUD/dead_energy.png")

export (int) var speed = 100
export (int) var knockback_speed = 500
export (int) var health = 10
export (int) var energy = 5

onready var area = $Area2D
onready var sprite = $AnimatedSprite
onready var animation_player = $AnimationPlayer
onready var tween = $Tween

var touch_left := false
var touch_right := false
var touch_up := false
var touch_down := false
var attack := false

var charging_bow = false
var bow_power = 0
var bow_damage = 0

var timer = null
var arrow_delay = 0.5
var can_shoot = true

var velocity := Vector2()
var is_taking_damage = false

signal player_died

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
	if Input.is_action_pressed("ui_accept") and not charging_bow && can_shoot || attack and not charging_bow and can_shoot:
		charging_bow = true
		velocity = Vector2.ZERO
		sprite.play("Attack_Bow")
		tween.interpolate_property(self, "bow_power", 3, 8, 5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
	elif Input.is_action_just_released("ui_accept") && can_shoot || attack and can_shoot:
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
		print("Shoot")
		
		#Optimize Arrow
		if get_tree().get_nodes_in_group("arrows").size() >= 3:
			for arrow in get_tree().get_nodes_in_group("arrows"):
				arrow.queue_free()
				print("deleted arrows")
	
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
	update_health()
	update_energy()
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
		"Slime", "Slime2", "Slime3":
			take_damage(body)
			
func take_damage(from_body):
	if not is_taking_damage:
		is_taking_damage = true
		health -= 1
		print("Player Health: " + str(health))
		var diff = global_position - from_body.global_position
		var direction = diff / Vector2(abs(diff.x), abs(diff.y))
		velocity = direction * Vector2(knockback_speed, knockback_speed)
		animation_player.play("taking_damage")
		yield(animation_player, "animation_finished")
		is_taking_damage = false
			
#Update Health
onready var heart1 = get_tree().get_root().get_node("World/HUD/HP/Health1")
onready var heart2 = get_tree().get_root().get_node("World/HUD/HP/Health2")
onready var heart3 = get_tree().get_root().get_node("World/HUD/HP/Health3")
onready var heart4 = get_tree().get_root().get_node("World/HUD/HP/Health4")
onready var heart5 = get_tree().get_root().get_node("World/HUD/HP/Health5")

func update_health():
	if health == 10:
		heart5.set_texture(full_heart)
	if health == 9:
		heart5.set_texture(half_heart)
	if health == 8:
		heart5.set_texture(empty_heart)
	if health == 7: 
		heart4.set_texture(half_heart)
	if health == 6:
		heart4.set_texture(empty_heart)
	if health == 5:
		heart3.set_texture(half_heart)
	if health == 4:
		heart3.set_texture(empty_heart)
	if health == 3:
		heart2.set_texture(half_heart)
	if health == 2:
		heart2.set_texture(empty_heart)
	if health == 1:
		heart1.set_texture(half_heart)
	if health <= 0:
		heart1.set_texture(empty_heart)
		
#Update Energy
onready var energy1 = get_tree().get_root().get_node("World/HUD/Energy/Energy1")
onready var energy2 = get_tree().get_root().get_node("World/HUD/Energy/Energy2")
onready var energy3 = get_tree().get_root().get_node("World/HUD/Energy/Energy3")
onready var energy4 = get_tree().get_root().get_node("World/HUD/Energy/Energy4")
onready var energy5 = get_tree().get_root().get_node("World/HUD/Energy/Energy5")

func update_energy():
	if energy == 5:
		energy5.set_texture(full_bolt)
	if energy == 4:
		energy5.set_texture(empty_bolt)
	if energy == 3:
		energy4.set_texture(empty_bolt)
	if energy == 2: 
		energy3.set_texture(empty_bolt)
	if energy == 1:
		energy2.set_texture(empty_bolt)
	if energy == 0:
		energy1.set_texture(empty_bolt)
		
func die():
	if health <= 0:
		print("Player Died")
		emit_signal("player_died")
		health = 10
		energy = 5

func _on_attack_pressed():
	attack = true

func _on_attack_released():
	attack = false