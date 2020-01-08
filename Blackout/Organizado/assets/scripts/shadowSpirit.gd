extends KinematicBody2D

export (int) var speed = 250

var velocity := Vector2()

func _ready():
	$AnimatedSprite.play("idle")

func get_input():
	# Basically just turning input values into single boolean variables
	var move_right = Input.is_action_pressed("ui_shadow_right")
	var move_left = Input.is_action_pressed("ui_shadow_left")
	var move_up = Input.is_action_pressed("ui_shadow_up")
	var move_down = Input.is_action_pressed("ui_shadow_down")
	
	# Initializing variables
	var x_movement = 0
	var y_movement = 0
	
	# If moving horizontally
	if move_right or move_left:
		# We only want to set x movement here because otherwise it allows the player 
		# to move diagonally which has strange behavior
		x_movement = int(move_right) - int(move_left)
	# If moving vertically
	elif move_up or move_down:
		# See note above x_movement
		y_movement = int(move_down) - int(move_up)
		
	var move_to = Vector2(x_movement * speed, y_movement * speed)
	velocity = lerp(velocity, move_to, 0.2)

# warning-ignore:unused_argument
func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)