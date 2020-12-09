extends Control


export var text_print = false
export var speed = 1.0
var print_speed

export var ready_for_next_text = false

signal print_finish
signal next_text


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if text_print == true and $Label.percent_visible < 1:
		$Label.percent_visible += print_speed
	elif $Label.percent_visible == 1:
		text_print = false
		ready_for_next_text = true
		#mit_signal("print_finish")
	
	if Input.is_action_just_pressed("interact") and ready_for_next_text == true:
		emit_signal("next_text")

func text_setting(text):
	if !text:
		$Label.bbcode_text = ""
		hide()
		get_node("/root/Spatial/player").active = true
		ready_for_next_text = false
	else:
		show()
		$Label.percent_visible = 0
		$Label.bbcode_text = text
		print_speed = speed/float(text.length())
		print(print_speed)
		text_print = true
		get_node("/root/Spatial/player").active = false
