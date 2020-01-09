extends RichTextLabel

var dialog = ["Onde é que eu estou?", "Como é que eu vim aqui parar?", "Quem...sou eu?", "Tu sabes porque estás aqui...Zell", "Ei! Espera aí! Como sabes o meu nome?"]
var page = 0
var s = Vector2()

onready var voice = get_tree().get_root().get_node("Polygon2D/AnimatedSprite")

func _ready():
	set_bbcode(dialog[page])
	set_visible_characters(0)
	set_process_input(true)
	
func _input(event):
	if Input.is_action_pressed("ui_accept"):
		if get_visible_characters() > get_total_character_count():
			if page < dialog.size()-1:
				page += 1
				set_bbcode(dialog[page])
				set_visible_characters(0)
			if page == 3:
				voice.play("shadow_spirit")
				s.x = 2
				s.y = 2
				voice.scale = s
			elif page == 4:
				voice.play("zell")
				s.x = 5
				s.y = 5
				voice.scale = s

func _on_Timer_timeout():
	set_visible_characters(get_visible_characters()+1)
