extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalRef.textbox = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func text_setting(text, duration):
	if !visible:
		show()
	$Label.text = text
	$AnimationPlayer.play("fade_in")
	$Timer.wait_time = duration
	$Timer.start()


func Timer_timeout():
	$AnimationPlayer.play("fade_out")
	pass # Replace with function body.


func animation_finished(anim_name):
	if anim_name == "fade_out":
		hide()
	pass # Replace with function body.
