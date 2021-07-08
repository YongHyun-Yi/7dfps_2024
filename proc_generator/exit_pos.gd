tool
extends Position3D
class_name proc_gen_exit

export var connected = false

enum tags {Room, Corridor, Junction}

export (bool) var Room
export (bool) var Corridor
export (bool) var Junction

var connectable_tag = []


# Called when the node enters the scene tree for the first time.
func _ready():
	if Room:
		connectable_tag.append(tags.Room)
	if Corridor:
		connectable_tag.append(tags.Corridor)
	if Junction:
		connectable_tag.append(tags.Junction)
	
	get_parent().exits.append(self)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
