extends Control


onready var text_box = $text_box
onready var anim = $AnimationPlayer
onready var tween = $Tween

export var display_speed = 1.0


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalRef.textbox = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if text_box.text != "":
		if text_box.percent_visible < 1.0:
			text_box.percent_visible += display_speed / text_box.text.length()
		else:
			messege_fade_out()
			text_box.text = ""
	
	pass

func set_messege(messege_text):
	text_box.text = messege_text
	messege_fade_in()

func messege_fade_in(time = 0.3):
	tween.interpolate_property(text_box, "modulate:a", 0, 255, time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func messege_fade_out(time = 0.3):
	tween.interpolate_property(text_box, "modulate:a", 255, 0, time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
