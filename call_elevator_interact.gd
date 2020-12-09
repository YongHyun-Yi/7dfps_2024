extends Interactable

export (NodePath) var target_elevator
export var target_floor = 0

signal call_elevator(t_f)


# Called when the node enters the scene tree for the first time.
func _ready():
	action = actions.hand
	target_elevator = get_node(target_elevator)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func interact():
	if active and !target_elevator.moving:
		emit_signal("call_elevator", target_floor)

func active_switch():
	if target_elevator.moving:
		active = false
	else:
		active = target_elevator.current_floor != target_floor
		print(target_elevator.current_floor)
		print(target_floor)
