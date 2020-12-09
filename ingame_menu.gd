extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if !visible:
			GlobalRef.hud.get_parent().set_disable_input(false)
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			show()
	
	if Input.is_action_just_pressed("ui_cancel"):
		if visible:
			GlobalRef.hud.get_parent().set_disable_input(true)
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			hide()
	pass
