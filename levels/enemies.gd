extends Spatial


export (NodePath) var nav


# Called when the node enters the scene tree for the first time.
func _ready():
	nav = get_node(nav)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

