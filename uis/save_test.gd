extends Interactable


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	action = actions.see
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func interact():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	GlobalRef.save_menu.show()
	GlobalRef.save_menu.has_focus()
