extends Interactable

export (NodePath) var target_elevator
export var target_floor = 1

signal move_elevator(t_f)


# Called when the node enters the scene tree for the first time.
func _ready():
	action = actions.hand
	target_elevator = get_node(target_elevator)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func interact():
	if active:
		emit_signal("move_elevator", target_floor)
		#target_floor = wrapi(target_floor + 1, 0, target_elevator.floor_position.get_child_count())

func active_switch():
	active = !active
	target_floor = wrapi(target_elevator.current_floor + 1, 0, target_elevator.floor_position.get_child_count())

