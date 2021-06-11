extends Interactable


export var turn_on = false
export var usable = true

export (NodePath) var lights

# Called when the node enters the scene tree for the first time.
func _ready():
	lights = get_node(lights)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func interact():
	if usable:
		if turn_on:
			lights.hide()
		else:
			lights.show()
		turn_on = !turn_on
	pass
