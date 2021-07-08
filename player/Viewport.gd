extends Viewport


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)
	set_process_unhandled_input(true)


func _input(event):
	unhandled_input(event)
	pass
