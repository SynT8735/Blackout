extends KinematicBody2D

onready var sprite = $Sprite
onready var shadow_spirit = get_tree().get_root().get_node("World/ss_bridge")

func _ready():
	sprite.play("ss")

func _on_triggerBridge_body_entered(body):
	if "Player" in body.name:
		shadow_spirit.queue_free()
		print("funfa")
