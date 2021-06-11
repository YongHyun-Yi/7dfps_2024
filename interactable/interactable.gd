extends Node

class_name Interactable

enum actions {hand, talk, add_item, pick_up, see, lock}
var action

export var active = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_interaction_icon():
	#GlobalRef.uis.get_node("cursor").set_icon(action, active)
	pass


func interact():
	pass
