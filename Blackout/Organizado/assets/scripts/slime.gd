extends KinematicBody2D

export (int) var speed
export (int) var damage
export (int) var max_health

var velocity = Vector2.ZERO
var player = preload("res://Scenes/player.tscn").instance()
var is_entered = null

onready var player_container = get_node("player_container")

func _ready():
	player_container.add_child(player)
	
func _physics_process(delta):
	velocity = Vector2.ZERO
	if is_entered:
		velocity = (player.position - position).normalized() * speed
	velocity = move_and_slide(velocity)

func _on_Area2D_area_entered(area):
	is_entered = area

func _on_Area2D_area_exited(area):
	is_entered = null
